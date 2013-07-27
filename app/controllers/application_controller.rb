class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    options = {}
    @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN) #,  env:  request.try(:env))
  end

  def mixpanel_waga
    mixpanel.track "waga", count: 5
  end
end
