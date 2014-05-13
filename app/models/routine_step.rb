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
