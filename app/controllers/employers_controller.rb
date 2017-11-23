class EmployersController < ApplicationController

  def create
    @employer = Employer.from_hash(params[:employer])
    respond_to do |format|
      if @employer.valid?
        notify_slack(@employer)
        flash[:notice] = "Thank you for joining Le Wagon's network."
        format.html { redirect_to employers_path }
      else
        format.html { render "pages/employers" }
      end
    end
  end

  private

  def notify_slack(employer)
    NotifySlack.perform_later(
      "channel": Rails.env.development? ? "test" : "hiring",
      "username": "www",
      "icon_url": "https://raw.githubusercontent.com/lewagon/mooc-images/master/slack_bot.png",
      "text": employer.to_slack_message
    )
  end
end
