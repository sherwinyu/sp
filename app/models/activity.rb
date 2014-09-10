class Activity
  include Mongoid::Document

  field :name
  has_many :rescue_time_dps

end
