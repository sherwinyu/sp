class AddActivities < Mongoid::Migration

  def self.cutoff
    DateTime.new(2014, 9, 1)
  end

  def self.rtdps
    RescueTimeDp.where(:time.gte => cutoff)
  end

  def self.up

    puts "rtdps.length: #{rtdps.length}"
    rtdps.each do |rtdp|

      rtdp.sync_against_raw
      rtdp.save
    end
  end

  def self.down
  end

end
