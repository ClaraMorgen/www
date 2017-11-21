class EmployersController < ApplicationController
  def new
    @employer = Employer.new
  end

  def create
    @employer = Employer.from_hash(params[:employer])

    respond_to do |format|
      if @employer.valid?
        notify_slack(@employer)
        flash[:notice] = 'Employer was successfully created.'
        format.html { redirect_to employers_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  private

  def notify_slack(employer)
    text = format_text_message(employer)
    NotifySlack.perform_later(
      # "channel": Rails.env.development? ? "test" : "incoming",
      "channel": Rails.env.development? ? "test" : "incoming",
      "username": "www",
      "icon_url": "https://raw.githubusercontent.com/lewagon/mooc-images/master/slack_bot.png",
      "text": text
    )
  end

  def format_text_message(employer)
"*Person:* #{employer.full_name} - #{employer.email} - #{employer.phone_number}
*Company:* #{employer.company}
*Company Website:* #{employer.website}
*Why:* #{employer.message}
*Which city:* #{employer.locations.reject { |l| l.empty? }.join(", ")}
*Looking for:* #{employer.targets.reject { |l| l.empty? }.join(", ")}"
  end
end
