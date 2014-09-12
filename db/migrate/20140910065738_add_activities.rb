class AddActivities < Mongoid::Migration

  def self.cutoff
    DateTime.new(2014, 9, 1)
  end

  def self.rtdps
    RescueTimeDp.where(:time.gte => cutoff)
  end

  def self.up
    # get all activities
    rtdps.each do |rtdp|
      rtdp.activities.each do |name, activity|
        a = Activity.where(names: name).first
        a ||= Activity.new(names: [name],
                           category: activity.category,
                           productivity: activity.productivity)
        a.save
      end

      rtdps
    end
  end

  def self.down
  end

end
