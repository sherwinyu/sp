##
# Contract:
#   Routines are immutable
#   Each routine contains a set of RoutineSteps
#
class Routine
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  embeds_many :routine_steps
end

