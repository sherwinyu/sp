class RescueTimeDpSerializer < ActiveModel::Serializer
  attributes :time, :activities, :id

  def id
    object.id.to_s
  end

  def activities
    object.get_activities
  end

  # def activities
    # object.activities.map { |name, activity| [name, {duration: activity.duration, }
  # end
end
