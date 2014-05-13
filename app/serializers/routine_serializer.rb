class RoutineSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :routine_steps
end
