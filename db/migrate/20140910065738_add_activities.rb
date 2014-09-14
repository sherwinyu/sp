class AddActivities < Mongoid::Migration

  def self.cutoff
    DateTime.new(2014, 9, 1)
  end

  def self.rtdps
    RescueTimeDp.where(:time.gte => cutoff, :acts.exists => false)
  end

  def self.up
    # get all activities
    rtdps.each do |rtdp|
      acts = []
      rtdp.activities.each do |name, activity|
        a = Activity.where(names: name).first
        a ||= Activity.new(names: [name],
                           category: activity.category,
                           productivity: activity.productivity)
        a.save
        acts << {a: a.id, activity.duration}
      end
      rtdp.acts = acts
      rtdp.save
      rtdps
    end
  end

  def self.down
  end

end
