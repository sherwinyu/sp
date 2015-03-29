class Day
  include Mongoid::Document
  include Mongoid::Timestamps
  # field :sleep, type: HumonNodeSleep
  extend Forwardable

  embeds_one :sleep
  embeds_one :summary, class_name: "Summary", store_as: 'summary'
  embeds_many :goals
  has_many :acts

  scope :recent, -> { where(:date.gte => 7.days.ago).desc(:date) }
  def_delegators :sleep, *%w[
    awake_at
    up_at
    awake_energy
    up_energy
  ]

  field :tz, type: String


  # Defaults to 4AM
  field :date, type: Date, default: -> {Date.current}
  field :start_at, type: Time, default: -> {_default_start_at}

  field :note, type: String

  validates_presence_of :start_at
  validates_uniqueness_of :date
  validates_presence_of :date

  def timezone
    Rollbar.warn "Day#timezone with #{date} defaulting to Option.current_timezone"
    ActiveSupport::TimeZone.new(self.tz || Option.current_timezone)
  end

  def start
    start_at or _default_start_at
  end

  def end_
    tomorrow.try(:start) or _default_start_at + 1.day
  end

  def time_range
    (start..end_)
  end

  default_scope -> { asc(:date) }

  def weekday
    date.strftime("%A")
  end

  ##
  # Computes the latest date based on the default timezone.
  def self.latest
    date = Util::DateTime.dt_to_expd_date Time.now
    day = Day.find_or_create_by date: date
    day
  end

  ##
  # @param time a physical time
  def self.from_time time
    Day.where(:start_at.lte => time).desc(:start_at).limit(1)
  end

  def yesterday
    Day.find_by date: date.yesterday
  end

  def tomorrow
    Day.find_by date: date.tomorrow
  end

  def yesterday!
    Day.on date.tomorrow
  end

  def tomorrow!
    Day.on date.tomorrow
  end

  def self.on arg
    date = Util::DateTime.to_date arg
    self.find_or_initialize_by date: date
  end

  private

  def _default_start_at
    # date.to_datetime gives it a UTC timestamp.
    # Then we convert to_time (giving it a local timezone)
    # Then we convert utc (shifting it back to utc, but now as a Time)
    # NOTE: use timezone.now to handle dst
    time = self.date.to_datetime.to_time.utc - timezone.now.utc_offset + 4.hours
    time.in_time_zone Util::DateTime.as_tz
  end
end
