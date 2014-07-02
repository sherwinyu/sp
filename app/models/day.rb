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

  field :note, type: String
  field :date, type: Date, default: -> {Date.today}

  validates_uniqueness_of :date
  validates_presence_of :date

  default_scope -> { asc(:date) }

  def weekday
    date.strftime("%A")
  end

  ##
  # Computes the latest date based on the default timezone.
  def self.latest
    date = Util::DateTime.dt_to_expd_date Time.now
    day = Day.find_or_create_by date: date
  end


  def yesterday
    Day.find_by date: date.yesterday
  end

  def tomorrow
    Day.find_by date: date.tomorrow
  end

  def self.on arg
    date = Util::DateTime.to_date arg
    self.find_or_initialize_by date: date
  end
end
