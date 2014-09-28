class Activity
  include Mongoid::Document

  field :name, type: String
  field :category, type: String
  field :productivity, type: Integer

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
