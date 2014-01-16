# sleep is NOT an act
class Sleep
  include Mongoid::Document
  embedded_in :day
  # references_many :SleepActs

  field :awake_at, type: DateTime
  field :up_at, type: DateTime
  field :melatonin_at, type: DateTime
  field :computer_off_at, type: DateTime
  field :lights_out_at, type: DateTime

  field :awake_energy, type: Integer
  field :up_energy, type: Integer
  field :computer_off_energy, type: Integer
  field :lights_out_energy, type: Integer

  # field :alarms
  # field :naps
end
