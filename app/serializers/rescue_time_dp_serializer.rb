class RescueTimeDpSerializer < ActiveModel::Serializer
  attributes :time, :activities, :id

  def id
    object.id.to_s
  end

  def activities
    pairs = object.acts.map do |act|
      activity = Activity.find act['a']
      [activity.name || activity.names.first, {duration: act['duration'], productivity: activity.productivity}]
    end
    Hash[pairs]
  end

  # def activities
    # object.activities.map { |name, activity| [name, {duration: activity.duration, }
  # end
end
