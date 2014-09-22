class Activity
  include Mongoid::Document

  field :name, type: String
  field :names, type: Array
  has_many :rescue_time_dps

  field :category
  field :productivity

  # def name
    # self.names.first
  # end

end
