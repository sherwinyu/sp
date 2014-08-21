class TwilioMessage

  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :from, type: String
  field :to, type: String
  field :status, type: String
  field :raw
end
