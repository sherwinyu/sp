# 1397541600000

task :remove_rtdp_duplicates => :environment do
  t = Time.at(1397541600)
  rtdps = RescueTimeDp.where(time: t).to_a
  puts "Found #{rtdps.count} rtdps at #{t}"

  if rtdps.count > 1
    rtdps.second.delete
    puts 'Deleted'
  end
end
