module Util
  class Log
    def self.mixpanel
      @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN)
    end

    def self.warn message, opts={}
      mixpanel.track "warning", opts.merge(message: message)
    end

  end
end
