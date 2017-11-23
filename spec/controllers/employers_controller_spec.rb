require 'rails_helper'

RSpec.describe EmployersController, type: :controller do
  it "notifies Slack" do
    ActiveJob::Base.queue_adapter = :test
    params = {
      first_name: "Alan",
      last_name: "Turing",
      phone_number: "3456789",
      email: "alan@turing.com",
      company: "E Corp.",
      website: "www.ecorp.com",
      targets: ["FullStack Developer", "Product Manager"],
      locations: ["Tokyo", "Paris"],
      message: "Realllllyyyyyy long text of more"
    }
    employer = Employer.from_hash(params)
    post :create, params: { employer: params }
    # expect(NotifySlack).to have_enqueued_sidekiq_job(channel: "hiring", text: employer.to_slack_message)
    expect(NotifySlack).to have_been_enqueued
  end
end
