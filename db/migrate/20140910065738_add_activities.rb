class AddActivities < Mongoid::Migration

  def self.cutoff
    DateTime.new(2014, 9, 1)

  end
  def self.rtdps
    RescueTimeDp.where( :time.gte => 1.week.ago )
  end

  def self.up
    rtdps.activities
  end

  def self.down
  end
end
