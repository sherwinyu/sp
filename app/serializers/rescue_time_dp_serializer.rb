class RescueTimeDpSerializer < ActiveModel::Serializer
  attributes :time, :activities, :id
  # def activities
    # object.activities.map { |name, activity| [name, {duration: activity.duration, }
  # end

end
