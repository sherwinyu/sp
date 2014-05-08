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

##
# A routine step is a series of
#
class RoutineStep
  include Mongoid::Document
  embedded_in  :routine

  # optional
  field :offset, type: Integer
  field :description, type: String
end
