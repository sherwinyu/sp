class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :category, type: String
  field :productivity, type: Integer
  field :duration, type: Integer

  index({ name: 1 }, {unique: true})
  index({ duration: 1 })

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

  # returns a list of {a: id, duration: integer} objects
  def acts
    rtdps.map do |rtdp|
      act = rtdp.acts.find { |a| a['a'] == self.id }
      act
    end
  end

  def compute_duration
    duration_sum = acts.sum { |act| act['duration'] }
    self.update_attribute(:duration, duration_sum)
  end

  def self.recent(limit=20)
    Activity.desc(:updated_at).limit limit
  end

  def self.most_duration(limit=20)
    Activity.desc(:duration).limit limit
  end

  def as_j
    ActivitySerializer.new(self).as_json
  end

  def as_json
    as_j
  end
end
