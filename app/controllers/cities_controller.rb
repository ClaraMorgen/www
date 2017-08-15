class CitiesController < ApplicationController
  include CitiesHelper

  def show
    city_slug = params[:city]

    @top_bar_message = I18n.t('.top_bar_message')
    @top_bar_cta = I18n.t('.top_bar_cta')
    @top_bar_url = demoday_index_path

    if city_slug.downcase != city_slug
      redirect_to city_path(city: city_slug.downcase)
      return
    end

    # TODO add cache
    @city = Kitt::Client.query(City::Query, variables: { slug: city_slug }).data.city

    if I18n.locale == I18n.default_locale &&
        @city.locale.to_sym != I18n.locale &&
        !session[:city_locale_already_forced] &&
        (request.env["HTTP_ACCEPT_LANGUAGE"] || "").split(",").first =~ /^#{Regexp.quote(@city.locale)}/
      redirect_to city_path(city_slug, locale: @city.locale)
      session[:city_locale_already_forced] = true
      return
    end

    @reviews = ReviewsCounter.new.review_count

    if request.format.html? || params[:testimonial_page]
      @testimonials = Testimonial.where(route: city_slug)
      if @testimonials.empty?
        @testimonials = Testimonial.where(route: Testimonial::DEFAULT_ROUTE)
      end
      @testimonials = Kaminari.paginate_array(@testimonials).page(params[:testimonial_page]).per(6)
    end

    if @city.current_batch
      pedagogic_team = @city.current_batch.teachers.sort_by { |teacher| teacher.user.github_nickname }
      lead_teachers = lead_teachers(@city)
      teachers = pedagogic_team - lead_teachers
      @assistants = teachers.reject { |teacher| teacher.lecturer }
      teachers -= @assistants
      @teachers = lead_teachers.concat(teachers)
    end

    @staff = Static::STAFF[city_slug.to_sym]

    meetup_cli = MeetupApiClient.new(@city.meetup_id)
    @meetup = { events: meetup_cli.meetup_events, infos: meetup_cli.meetup  }
    session[:city] = @city.slug

    # Next batch
    @next_batch = @city.next_batch
  end
end
