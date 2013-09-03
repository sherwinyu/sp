class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :submitted_at, :details
end
