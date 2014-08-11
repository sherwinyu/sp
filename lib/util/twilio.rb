module Util
  class Twilio
    def self.twilio_client
      ::Twilio::REST::Client.new(
        Figaro.env.TWILIO_SID,
        Figaro.env.TWILIO_AUTH_TOKEN
      )
    end
  end
end
