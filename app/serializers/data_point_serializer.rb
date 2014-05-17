class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :at, :ended_at, :details, :type
  def id
    object.id.to_s
  end
end
