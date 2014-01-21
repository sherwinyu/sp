class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :at, :ended_at, :details, :_type
end
