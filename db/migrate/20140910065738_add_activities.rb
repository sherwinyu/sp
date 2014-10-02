class AddActivities < Mongoid::Migration
  # Migrate from the old RescueTimeDp#activities to the new RescueTimeDp#acts
  #
  # In the old schema, activities were stored as a hash, with activit name keys
  # => object hashes.
  #
  # In new schema, acts is an array of hashes, each with an Activity id and duration
  #
  # This migration finds all RescueTimeDps that has the old "activities" field and
  # doesn't have the new "acts" field and converts them
  #
  # It also removes all activities fields

  def self.rtdps
    RescueTimeDp.where(:activities.exists => true, :acts.exists => false)
  end

  def self.up
    puts "rtdps.length: #{rtdps.length}"
    rtdps.each do |rtdp|
      rtdp.sync_against_raw
      rtdp.activities = nil
      rtdp.save
      puts rtdp.time
    end
    RescueTimeDp.where(:activities.exists => true, :acts.exists => true).unset(:activities)
  end

  def self.down
  end

end
