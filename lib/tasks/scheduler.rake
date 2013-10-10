desc "This task is called by the Heroku scheduler add-on"
task :import_rescue_time => :environment do
  puts "Importing from rescue time..."

  rtdps, report = RescueTimeImporter.import

  report[:existing_rtrs] ||= []
  report[:existing_rtdps] ||= []
  report[:new_rtrs] ||= []
  report[:new_rtdps] ||= []
  existing_rtr_times = report[:existing_rtrs].map(&:experienced_time)
  new_rtr_times = report[:new_rtrs].map(&:experienced_time)

  existing_rtdp_times = report[:existing_rtdps].map(&:experienced_time)
  new_rtdp_times = report[:new_rtdps].map(&:experienced_time)

  puts "Import done."
  puts "#{report[:existing_rtrs].count} existing RTRs upserted, spanning time range #{existing_rtr_times.min} - #{existing_rtr_times.max}"
  puts "#{report[:new_rtrs].count} new RTRs created, spanning time range #{new_rtr_times.min} - #{new_rtr_times.max}"
  puts "#{report[:existing_rtdps].count} existing RTDPs upserted spanning time range #{existing_rtdp_times.min} - #{existing_rtdp_times.max}"
  puts "#{report[:new_rtdps].count} new RTDPs created spanning time range #{new_rtdp_times.min} - #{new_rtdp_times.max}"
end
