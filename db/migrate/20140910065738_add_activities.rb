class AddActivities < Mongoid::Migration

  def self.cutoff
    DateTime.new(2014, 9, 1)
  end

  def self.rtdps
    RescueTimeDp.where(:time.gte => cutoff, :acts2.exists => false)
  end

  def self.up

    puts "rtdps.length: #{rtdps.length}"
    rtdps.each do |rtdp|

      activities_list = RescueTimeImporter.activities_list_from_rtrs rtdp.rtrs

      rtdp.acts2 = activities_list
      rtdp.save

      # acts = []
      # rtdp.activities.each do |name, activity|
      # a = Activity.where(names: name).first
      # a ||= Activity.new(names: [name],
                           # category: activity.category,
                           # productivity: activity.productivity)
      # a.save
      # acts << {a: a.id, duration: activity.duration }
      # end
      # rtdp.acts2 = acts
      # rtdp.save
    end
  end

  def self.down
  end

end
