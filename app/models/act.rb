class Act
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :duration,  type: Integer
  field :start_time, type: DateTime
  field :end_time, type: DateTime
end
