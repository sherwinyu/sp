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
        MIXPANEL_TOKEN: Figaro.env.MIXPANEL_TOKEN,
        RAILS_ENV: Rails.env
      },
      git: Util::Git.git,
      currentUser: current_user.as_json,
      heartbeat: heartbeat,
      isTest: Rails.env.test?
    })
  end

  # /ping
  def ping
    if Time.zone.now > Option.next_ping_time
      send_twilio_msg
      delta = 35.minutes + rand(30).minutes
      Option.next_ping_time = Time.zone.now + delta
    end
    render json: heartbeat, status: 200
  end

  private

  def send_twilio_msg
    return unless Util::DateTime.currently_awake
    puts "Sending message!"
    Util::Twilio.send_message "Energy / status / happyiness? #{Time.zone.now}"
  end

  def heartbeat
    {
      latest_day_id: Day.latest.date.to_s,
      time: Time.zone.now,
      next_ping_time: Option.next_ping_time
    }
  end


end
