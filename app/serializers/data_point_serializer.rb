class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :submitted_at, :at, :ended_at, :details
end
