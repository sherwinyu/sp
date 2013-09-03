class DataPoint
  include Mongoid::Document
  field :submitted_at, type: Time
  field :details
end
