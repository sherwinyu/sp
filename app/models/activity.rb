class Activity
  include Mongoid::Document

  field :name, type: String
  field :category, type: String
  field :productivity, type: Integer
  index({ name: 1 }, {unique: true})

  def self.upsert_activity_from_rtr rtr
    activity = Activity.where(name: rtr.rt_activity).first_or_initialize
    # Don't modify the activity if it already exists
    unless activity.persisted?
      activity.productivity = rtr.productivity
      activity.category = rtr.category
      activity.save
    end
    activity
  end

  def rtdps
    @rtdps ||= RescueTimeDp.where("acts.a" => self.id)
  end

  def acts
    rtdps.map do |rtdp|
      act = rtdp.acts.find { |a| a['a'] == self.id }
      act
    end
  end

  def duration
    acts.sum { |act| act['duration'] }
  end

end
