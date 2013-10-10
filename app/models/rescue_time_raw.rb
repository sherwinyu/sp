class RescueTimeRaw
  include Mongoid::Document
  include Mongoid::Timestamps
  field :synced_at, type: Time

  field :rt_date, type: String
  field :rt_time_spent, type: Integer
  field :rt_number_of_people, type: Integer
  field :rt_activity, type: String
  field :rt_category, type: String
  field :rt_productivity, type: Integer

  attr_readonly *%w[rt_date rt_number_of_people rt_activity]
  # time_spent is NOT read only because we might still be waiting on data

  validates_presence_of :rt_date
  validates_presence_of :rt_time_spent
  validates_presence_of :rt_activity

  # Accessor methods
  # And Method aliases
  def experienced_time
    Time.parse rt_date rescue nil
  end

  alias_method :time, :experienced_time
  alias_method :activity, :rt_activity
  alias_method :name, :rt_activity
  alias_method :productivity, :rt_productivity
  alias_method :category, :rt_category

  def hour
    time.hour
  end

  def day
    time.to_date
  end

  def duration
    rt_time_spent.seconds
  end

  def pretty_hour
    t1 = time
    t2 = time + 1.hour
    pm = t2.hour >= 12 ? "pm" : ""
    "#{(t1.hour - 1) % 12 + 1}-#{(t2.hour - 1) % 12 + 1}#{pm}"
  end

  def pretty_duration
    Time.at(duration).utc.strftime "%Mm %Ss" rescue nil
  end


  def to_s
    "#{day} @ #{pretty_hour}, activity: #{activity}, duration: #{pretty_duration}"
  end

end
