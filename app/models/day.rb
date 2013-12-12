class Day
  include Mongoid::Document
  include Mongoid::Timestamps
  # field :sleep, type: HumonNodeSleep
  extend Forwardable

  embeds_one :sleep, class_name: "SpSleep", store_as: 'sleep'
  embeds_one :summary, class_name: "Summary", store_as: 'summary'
  embeds_many :goals

  def_delegators :sleep, *%w[
    awake_at
    awake_energy
    up_at
    up_energy
  ]

  field :note, type: String
  field :date, type: Date, default: -> {Date.today}

  validates_uniqueness_of :date
  validates_presence_of :date

  default_scope asc(:date)

  def weekday
    date.strftime("%A")
  end

  #
  def self.latest
    date = Util::DateTime.time_to_experienced_date Time.now
    spd = Day.find_or_initialize_by date: date
  end

  def yesterday
    Day.find_by date: date.yesterday
  end

  def tomorrow
    Day.find_by date: date.tomorrow
  end

  def inspect
    "#{date.strftime}: #{super}"
  end

=begin
sleep
  begin
  energy
  night
  lights out

=end
end

