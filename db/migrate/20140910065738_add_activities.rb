class AddActivities < Mongoid::Migration


  def self.rtdps
    RescueTimeDp.where(:activities.exists => true, :acts.exists => false)
  end

  def self.up
    puts "rtdps.length: #{rtdps.length}"
    rtdps.each do |rtdp|
      rtdp.sync_against_raw
      rtdp.save
      puts rtdp.time
    end
  end

  def self.down
  end

end
