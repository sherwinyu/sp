class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    Util::Log.mixpanel
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
      git: Util::Git.git,
      currentUser: current_user.as_json,
      heartbeat: heartbeat
    })
  end

  def heartbeat
    {

      # latest_day_id: Day.latest.date.to_s,
      latest_day_id: Day.skip(rand Day.count).first.date.to_s,
      time: Time.zone.now
    }
  end

  def ping
    Time.now
    if Util::DateTime.currently_awake
      r = rand(400)
      puts "Random r: #{r} >?< 398"
      if r > 398
        puts "Sending message!"
        Util::Twilio.send_message "Energy / status / happyiness? #{Time.zone.now}"
      end
    end
    render json: heartbeat, status: 200
  end

end
