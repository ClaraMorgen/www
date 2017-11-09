class CachesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_shared_secret!

  class HttpAuthorizationHeaderException < Exception; end

  def destroy
    # TODO: Implement this for Kitt
    render body: nil
  end

  private

  def check_shared_secret!
    fail HttpAuthorizationHeaderException if request.headers['HTTP_AUTHORIZATION'] != ENV.fetch('ALUMNI_WWW_SHARED_SECRET')
  end
end
