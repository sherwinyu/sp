desc "resync all rescue time data points actitivites field"
task :rescue_time_resync_against_raw do
  puts "Resyncing all rescue time data points against raw"
  RescueTimeDp.each &:resynce_against_raw!
end

desc "resync all rescue time data points :time field"
task  :rescue_time_resync_time => :environment do
  puts "Resyncing all rescue time data points"
  RescueTimeDp.each &:resynce_time!
end
