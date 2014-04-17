class RescueTimeDp
  include Mongoid::Document
  include Mongoid::Timestamps
  scope :recent, where(:time.gte => 7.days.ago).desc(:time)

  # uniquely indexed by rt_date
  field :rt_date, type: String
  attr_readonly :rt_date

  field :time, type: Time # stored as UTC, can be updated; zone is implicit from offset with `experienced_time`
  field :activities, type: HumonNode

  # Returns an unzoned ("experienced") time, in UTC
  def experienced_time
    Time.parse(rt_date + "UTC") rescue nil
  end

  after_save :flush_cache
  def flush_cache
    Rails.cache.delete([self.class.name, "recent"])
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

  def resync_against_raw!(report=nil)
    rtdps = RescueTimeImporter.instantiate_rtdps_from_rtrs RescueTimeRaw.where(rt_date: rt_date), report
    reload
    rtdps
  end

  def resync_time!
    raise "not implemented"
    # self.update_attribute :time, <convert rt_date to absolute time>
  end

end
