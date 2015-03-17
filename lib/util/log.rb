module Util
  class Log
    def self.mixpanel
      @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN)
    end

    def self.warn message, opts={}
      puts '  Warning: ' + message
      mixpanel.track "warning", opts.merge(message: message)
      Rollbar.warn message
    end

  end
end
