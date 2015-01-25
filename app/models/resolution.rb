class Resolution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :group, type: String
  field :frequency, type: String
  field :type, type: String
  field :count, type: Integer
  field :completions
end
