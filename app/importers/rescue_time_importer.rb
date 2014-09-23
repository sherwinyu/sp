class RescueTimeImporter

  # Makes a request to the RescueTime analysis API
  # Returns the raw data (wrapped in a Hashie)
  #
  def self.rescue_time_api_query(opts={})
    data = Hash.new
    data[:key] = Figaro.env.RESCUETIME_TOKEN
    data[:format] = 'json'
    data[:operation] = 'select'
    data[:version] = '0'

    # by default, query for one day
    end_string = Date.current.tomorrow.strftime
    start_string = Date.current.yesterday.strftime
    data.merge!( {
      perspective: "interval",
      resolution_time: "hour",
      restrict_begin: start_string, #inclusive
      restrict_end: end_string, #exclusive
    })
    data.merge! opts
    p "Calling rescuetime with: ", data
    url = "https://www.rescuetime.com/anapi/data"
    json = Hashie::Mash.new JSON.parse(RestClient.post url, data)
  end

  def self.import(rel_time_range=nil)
    end_string = Date.current.tomorrow.strftime
    start_string = Date.current.yesterday.strftime
    rescue_time_json = rescue_time_api_query(restrict_begin: start_string, restrict_end: end_string)

    report = {}

    rtrs = rescue_time_json.rows.map{ |row| instantiate_rescue_time_raw_from_row row, report }
    rtdps = instantiate_rtdps_from_rtrs rtrs, report
    return rtdps, report
  end

  def self.instantiate_rtdps_from_rtrs(rtrs, report=nil)
    rtdps = []
    grouped = group_rtrs_by_date_and_hour rtrs
    grouped.each do |date, hours|
      hours.each do |hour, rtrs|
        rtdp = RescueTimeDp.find_or_initialize_by rt_date: rtrs.first.rt_date
        if report
          (report[:new_rtdps] ||= []) << rtdp if rtdp.new_record?
          (report[:existing_rtdps] ||= []) << rtdp if rtdp.persisted?
        end

        rtdp.time ||= Util::DateTime.rt_time_to_absolute_time(rtrs.first.rt_date)
        rtdp.update_attributes activities: activities_hash_from_rtrs(rtrs)
        rtdp.save
        rtdps << rtdp
      end
    end
    rtdps
  end

  # precondition: rtrs all belong to the same day and hour
  # ### --- new -> this method should
  #   create activity methods
  def self.activities_hash_from_rtrs rtrs
    activities = {}
    rtrs.each do |rtr|
      activity = sanitize_rt_activity_string rtr.rt_activity
      activities[activity] = {
        duration: rtr.duration,
        productivity: rtr.productivity,
        category: rtr.category
      }
    end
    activities
  end

  def self.activities_list_from_rtrs rtrs
    rtrs.map do |rtr|
      a = Activity.where(name: rtr.rt_activity).first_or_initialize
      a.productivity = rtr.productivity
      a.category = rtr.category
      a.save
      {a: a.id, duration: rtr.duration}
    end
  end

  def self.sanitize_rt_activity_string rt_activity
    rt_activity.downcase.gsub(/[. -\/]/, '_')
  end

  def self.group_rtrs_by_date_and_hour rtrs
    grouped = Hash[
      rtrs.group_by(&:day).map do |day, rtrs|
        [day, rtrs.group_by(&:hour)]
      end
    ]
    return grouped
  end

  # upserts a row
  def self.instantiate_rescue_time_raw_from_row(row, report=nil)
    rtr = RescueTimeRaw.find_or_initialize_by(rt_date: row[0], rt_activity: row[3])
    if report
      (report[:new_rtrs] ||= []) << rtr if rtr.new_record?
      (report[:existing_rtrs] ||= []) << rtr if rtr.persisted?
    end

    # implicitly saves rtr
    rtr.update_attributes(
      #[Date Time Spent (seconds)   Number of People  Activity   Category   Productivity ]
      synced_at: Time.current,
      rt_time_spent: row[1],
      rt_number_of_people: row[2],
      rt_category: row[4],
      rt_productivity: row[5]
    )
    rtr
  end

end
