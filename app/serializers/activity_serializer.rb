class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :productivity

  def id
    object.id.to_s
  end

end
