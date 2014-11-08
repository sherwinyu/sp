require 'benchmark'

class AddDurationToActivity < Mongoid::Migration
  def self.up
    self.add_duration_to_activity1
  end

  def self.add_duration_to_activity1
    pairs = Activity.all.map do |activity|
      [activity.id, 0]
    end

    activities = Hash[pairs]
    part1 = Benchmark.ms do
      RescueTimeDp.all.each do |rtdp|
        rtdp.acts.each do |act|
          id = act['a']
          duration = act['duration']
          activities[id] += duration
        end
      end
    end
    puts 'part1', part1

    part2 = Benchmark.ms do
        activities.each do |id, value|
          Activity.find(id).update_attribute :duration, value
      end
    end
    puts 'part2', part2
    return activities
  end

  def self.add_duration_to_activity2
    pairs = Activity.all.map do |activity|
      [activity.id, 0]
    end

    activities = Hash[pairs]

    Activity.all.each do |activity|
      activities[activity.id] = activity.acts.sum {|act| act['duration']}
    end
    activities
  end

  def self.down
  end
end
