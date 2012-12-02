class ActionSerializer < ActiveModel::Serializer
  attributes :id, :description, :duration, :start_time, :end_time
end
