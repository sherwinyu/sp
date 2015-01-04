class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :productivity, :duration

  def id
    object.id.to_s
  end

end
