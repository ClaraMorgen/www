class StudentsController < ApplicationController
  respond_to :html, :js

  def index
    if request.format.html? || params[:testimonial_page]
      @testimonials = Testimonial.where(route: Testimonial::DEFAULT_ROUTE)
      @testimonials = Kaminari.paginate_array(@testimonials).page(params[:testimonial_page]).per(6)
    end

    if request.format.html? || params[:story_page]
      @stories = @client.stories
      @stories =  Kaminari.paginate_array(@stories).page(params[:story_page]).per(6)
    end

    if request.format.html?
      @statistics = @client.statistics
      @reviews = ReviewsCounter.new.review_count
    end
  end
end
