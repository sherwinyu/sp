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

  field :date, type: Date
  field :note, type: String

  def weekday
    date.strftime("%A")
  end

  validates_presence_of :date
  index({ date: 1 }, { unique: true, name: "date_index" })
end

