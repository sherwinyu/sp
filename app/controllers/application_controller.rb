class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    options = {}
    @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN)
  end

  before_filter :authorize
  def authorize
    Rack::MiniProfiler.authorize_request
  end

end
