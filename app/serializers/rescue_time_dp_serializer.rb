class RescueTimeDpSerializer < ActiveModel::Serializer
  attributes :time, :activities
  # def activities
    # object.activities.map { |name, activity| [name, {duration: activity.duration, }
  # end

end
