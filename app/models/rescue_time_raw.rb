class RescueTimeRaw
  include Mongoid::Document
  include Mongoid::Timestamps
  field :synced_at, type: Time
  field :date, type: Time

  field :rt_date
  field :rt_time_spent
  field :rt_number_of_people, type: Integer
  field :rt_activity, type: String
  field :rt_category, type: String
  field :rt_productivity, type: Integer

  def sync_timezone
    # calculate where i was "at this time" (aka, when I experienced 4pm)
    self.update_attribute :date, Time.parse(rt_date)
  end

  # Accessor methods
  # And Method aliases
  def time
    date
  end

  def day
    date.to_date rescue nil
  end

  def hour
    time.hour
  end

  def pretty_hour
    t1 = time
    t2 = time + 1.hour
    pm = t2.hour >= 12 ? "pm" : ""
    "#{t1.hour}:00-#{t2.hour}:00"
    "#{(t1.hour - 1) % 12 + 1}-#{(t2.hour - 1) % 12 + 1}#{pm}"
  end

  def duration
    rt_time_spent.seconds rescue nil
  end

  def pretty_duration
    Time.at(duration).utc.strftime "%Mm %Ss" rescue nil
  end

  def activity
    rt_activity
  end

  def name
    rt_activity
  end

  def productivity
    rt_productivity
  end

  def category
    rt_category
  end

  def to_s
    "#{day} @ #{pretty_hour}, activity: #{activity}, duration: #{pretty_duration}"
  end
end
