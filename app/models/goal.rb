class Goal
  include Mongoid::Document
  embedded_in :day

  field :goal, type: String
  field :completed, type: Boolean
  field :completed_at, type: DateTime
end

