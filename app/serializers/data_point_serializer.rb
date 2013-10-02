class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :submitted_at, :started_at, :ended_at, :details
end
