def mp_track name, opts
  mp = Util::Log.mixpanel
  puts "Mix panel tracking: #{name} =>"  #{opts}"
  ap opts
  mp.track(name, opts)
end

def ping_url url
  start = Time.now
  puts "Pinging server at #{url}"
  uri = URI(url)

  report = OpenStruct.new

  begin
    h = Net::HTTP.get_response(uri)
    report.http_result = h.code
    delta = Time.now - start
    report.delta = delta
  rescue Exception => e
    report.error = e.to_s
  ensure
    report.target = url
    puts "Result: "
    ap report.marshal_dump
    mp_track("ping", report.marshal_dump)
  end
end

def import_last_fm
  puts "Importing from LastFm"
  lfmdps, report = LastFmImporter.import

end
def import_rescue_time
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
  mp_report = Hash[report.map{|k,v| [k,v.count]}]
  mp_report.merge!(
    existing_rtr_times_min: existing_rtr_times.min,
    existing_rtr_times_max: existing_rtr_times.max,
    new_rtr_times_min: new_rtr_times.min,
    new_rtr_times_max: new_rtr_times.max,
    existing_rtdp_times_min: existing_rtdp_times.min,
    existing_rtdp_times_max: existing_rtdp_times.max,
    new_rtdp_times_min: new_rtdp_times.min,
    new_rtdp_times_max: new_rtdp_times.max
  )
  mp_track("rescuetime_import", mp_report)
  puts "#{report[:existing_rtrs].count} existing RTRs upserted, spanning time range #{existing_rtr_times.min} - #{existing_rtr_times.max}"
  puts "#{report[:new_rtrs].count} new RTRs created, spanning time range #{new_rtr_times.min} - #{new_rtr_times.max}"
  puts "#{report[:existing_rtdps].count} existing RTDPs upserted spanning time range #{existing_rtdp_times.min} - #{existing_rtdp_times.max}"
  puts "#{report[:new_rtdps].count} new RTDPs created spanning time range #{new_rtdp_times.min} - #{new_rtdp_times.max}"
end

task :hourly => :environment do
  if Figaro.env.PING_URL
    delta = ping_url Figaro.env.PING_URL
  end
  import_rescue_time
  import_last_fm
  ping_url "http://farmivore.com"
  ping_url "http://www.farmivore.com"
  ping_url "http://demo.weaveenergy.com"
  ping_url "http://newliving.weaveenergy.com"
  ping_url "http://staging-newliving.weaveenergy.com"
end

desc "This task is called by the Heroku scheduler add-on"
task :import_rescue_time => :environment do
  import_rescue_time
end
