class Sleep
  include Mongoid::Document
  embedded_in :day

  field :awake_at
  field :awake_energy
  field :up_at
  field :up_energy
end
