class Activity
  include Mongoid::Document

  field :name, type: String
  field :names, type: Array
  has_many :rescue_time_dps

  field :category
  field :productivity

  def self.upsert_activity_from_rtr rtr
    activity = Activity.where(name: rtr.rt_activity).first_or_initialize
    unless activity.persisted?
      activity.productivity = rtr.productivity
      activity.category = rtr.category
      activity.save
    end
    activity
  end
end
