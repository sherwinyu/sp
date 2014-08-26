class TwilioMessage

  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :from, type: String
  field :to, type: String
  field :status, type: String
  field :raw

  def self.from_sms sms
    body, _, comment = sms.partition '-'
    numbers = body.split.map(&:to_numeric)
    energy, focus, happiness = numbers
    comment.strip!

    details = {}
    details[:energy] = energy if energy.present?
    details[:focus] = focus if focus.present?
    details[:happiness] = happiness if happiness.present?
    details[:comment] = comment if comment.present?
    DataPoint.new at: Time.now, details: details
  rescue
    nil
  end
end
