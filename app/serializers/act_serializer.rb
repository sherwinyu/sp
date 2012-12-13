class ActSerializer < ActiveModel::Serializer
  attributes :id, :description, :duration, :start_time, :end_time, :errors
end
