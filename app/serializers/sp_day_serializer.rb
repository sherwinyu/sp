class SpDaySerializer < ActiveModel::Serializer
  attributes :id, :date, :note
  has_one :sleep
end
