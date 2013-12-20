class Sleep
  include Mongoid::Document
  embedded_in :day

  field :awake_at, type: DateTime
  field :awake_energy, type: Integer
  field :up_at, type: DateTime
  field :up_energy, type: Integer
end
