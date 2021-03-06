class RescueTimeDp
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :recent, -> (x=7) { where(:time.gte => (x).days.ago).desc(:time) }
  scope :most_recent, -> { desc(:time).limit(36) }

  index({time: 1}, {unique: true})
  index({rt_date: 1}, {unique: true})

  index({"acts.a" => 1})

  # uniquely indexed by rt_date
  field :rt_date, type: String
  attr_readonly :rt_date

  field :time, type: Time # stored as UTC, can be updated; zone is implicit from offset with `experienced_time`
  field :activities, type: HumonNode

  field :acts, type: Array

  def rtrs
    RescueTimeRaw.where(rt_date: self.rt_date)
  end

  # Returns an unzoned ("experienced") time, in UTC
  def experienced_time
    Time.parse(rt_date + "UTC") rescue nil
  end

  after_save :flush_cache
  after_save :update_activity_durations

  def flush_cache
    Rails.cache.delete([self.class.name, "recent"])
  end

  def update_activity_durations
    self.acts.each do |act|
      activity = Activity.find act['a']
      activity.compute_duration
    end
  end

  def self.cached_recent
    Rails.cache.fetch [name, "recent"] do
      recent.to_a
    end
  end

  def hour
    experienced_time.hour
  end

  def day
    experienced_time.to_date
  end

  def pretty_hour
    t1 = date_time
    t2 = date_time + 1.hour
    pm = t2.hour >= 12 ? "pm" : ""
    "#{(t1.hour - 1) % 12 + 1}-#{(t2.hour - 1) % 12 + 1}#{pm}"
  end

  def next
    hour
  end

  def self.on_day date
    date = Date.parse(arg) if arg.class == String
    date1 = date
    date2 = date + 1.day
    self.where(:date_time => date1..date2)
  end

  def sync_against_raw
    self.acts = RescueTimeImporter.activities_list_from_rtrs self.rtrs
  end

  def resync_time!
    raise "not implemented"
    # self.update_attribute :time, <convert rt_date to absolute time>
  end

  # read only activities hash
  def get_activities
    pairs = self.acts.map do |act|
      activity = Activity.find act['a']
      [activity.name, {duration: act['duration'], productivity: activity.productivity}]
    end
    Hash[pairs].freeze
  end

end
