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
  field :_id, type: Time, default: -> { Date.today }

  def date
    self.id.to_date
  end

  def weekday
    date.strftime("%A")
  end

  validates_presence_of :_id
  validates_uniqueness_of :_id
end

