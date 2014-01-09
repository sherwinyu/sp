class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    options = {}
    Util.mixpanel
  end

  before_filter :authorize
  def authorize
    # Rack::MiniProfiler.authorize_request
  end

  before_filter :inject_vars
  def inject_vars
    @server_side_vars = Hashie::Mash.new({
      env: {
        MIXPANEL_TOKEN: Figaro.env.MIXPANEL_TOKEN
      },
      git: Util::Git.git
    })
  end

end
