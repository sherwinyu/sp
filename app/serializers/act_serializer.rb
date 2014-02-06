class ActSerializer < ActiveModel::Serializer
  attributes :id, :at, :ended_at, :desc, :errors, :day

  def day
    object.day.date
  end
end
