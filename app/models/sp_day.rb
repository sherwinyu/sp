class SpDay
  include Mongoid::Document
  include Mongoid::Timestamps
  # field :sleep, type: HumonNodeSleep
  extend Forwardable

  embeds_one :sleep, class_name: "SpSleep", store_as: 'sleep'
  def_delegators :sleep, *%w[
    awake_at
    awake_energy
    up_at
    up_energy
  ]

  field :note, type: String
  field :date, type: Date, default: -> {Date.today}

  def date
    self.id.to_date
  end

  def weekday
    date.strftime("%A")
  end

  def self.latest
    date = Util.time_to_experienced_date Time.now
    spd = SpDay.find_or_initialize_by _id: date
  end

end

