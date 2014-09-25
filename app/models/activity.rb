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

  def self.upsert_activities_from_rtrs rtrs
    rtrs.map do |rtr|
      activity = Activity.where(name: rtr.rt_activity).first_or_initialize
      unless activity.persisted?
        activity.productivity = rtr.productivity
        activity.category = rtr.category
        activity.save
      end
      activity
    end
  end
end
