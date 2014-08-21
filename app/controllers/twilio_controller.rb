require 'twilio-ruby'

class TwilioController < ApplicationController
  # include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def parse_sms body
    return nil unless body =~/\d+\s+\d+\s+\d+/
    args = body.split.map &:to_i
    details = {energy: args[0], focus: args[1], happiness: args[2]}
    DataPoint.create at: Time.now, details: details
  rescue
    nil
  end

  def sms
    msg = TwilioMessage.new body: params[:Body], to: params[:To], from: params[:To], status: params[:Status]
    msg.raw = params.except(:action, :controller)
    msg.save
    dp = parse_sms msg.body
    response = Twilio::TwiML::Response.new do |r|
      if dp
        r.Message "Confirmed(#{Rails.env})! #{dp.to_msg} "
      else
        r.Message "energy / focus / happiness"
      end
    end
    render_twiml response
  end

  def voice
    puts params
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
      r.Play 'http://linode.rabasa.com/cantina.mp3'
    end
    render_twiml response
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end
  def render_twiml(response)
    render text: response.text
  end

end
