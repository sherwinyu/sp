class ActSerializer < ActiveModel::Serializer
  attributes :id, :at, :ended_at, :desc, :errors, :day

  def id
    object.id.to_s
  end

  def day
    object.day.date
  end
end
