module Util
  class Twilio

    def self.twilio_client
      @client ||= ::Twilio::REST::Client.new(
        Figaro.env.TWILIO_SID,
        Figaro.env.TWILIO_AUTH_TOKEN
      )
    end

    def self.send_message message
      if false
        twilio_client.account.messages.create(
          from: '+15716990058',
          to: '5707987565',
          body: message
        )
      end
    end

  end
end
