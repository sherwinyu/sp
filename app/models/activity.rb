class Activity
  include Mongoid::Document

  field :name
  field :names, type: Array
  has_many :rescue_time_dps

  field :category
  field :productivity

end
