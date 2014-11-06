class AddDurationToActivity < Mongoid::Migration
  def self.up

    pairs = Activity.all.map do |activity|
      [activity.id, 0]
    end

    activities = Hash[pairs]
    RescueTimeDp.limit(100).each do |rtdp|
      rtdp.acts.each do |act|
        id = act['a']
        duration = act['duration']
        activities[id] += duration
      end
    end
  end

  def method_1

  end

  def self.down
  end
end
