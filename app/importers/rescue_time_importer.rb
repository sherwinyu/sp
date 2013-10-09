class RescueTimeImporter
  def self.run opts={}
    # TODO(syu): look up latest RTRaw and use that as the time stamp boundary
    range = opts[:range] || (Time.now - 1.day)..(Time.now)
    rtrs = RescueTimeRaw.import(range)
    rtdps = RescueTimeDp.upsert_from_rescue_time_raws(rtrs)
  end

  # Makes a request to the RescueTime analysis API
  # Returns the raw data (wrapped in a Hashie)
  def self.rescue_time_api_query(opts={})
    data = Hash.new
    data[:key] = Figaro.env.RESCUETIME_TOKEN
    data[:format] = 'json'
    data[:operation] = 'select'
    data[:version] = '0'

    # by default, query for one day
    end_string = Time.now.strftime "%Y-%m-%d"
    start_string = 1.day.ago.strftime "%Y-%m-%d"
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

  def self.pull(rel_time_range=nil)
    end_string = Time.now.strftime "%Y-%m-%d"
    start_string = 1.day.ago.strftime "%Y-%m-%d"
    data = rescue_time_api_query(restrict_begin: start_string, restrict_end: end_string)
    data.rows.map do |row|
      instantiate_rescue_time_raw_from_row row
    end
  end

  def instantiate_rtdps_from_rtrs rtrs
    grouped = group_rtrs_by_date_and_hour rtrs
  end

  def self.group_rtrs_by_date_and_hour rtrs
    grouped = Hash[
      rtrs.group_by(&:day).map do |date, rtrs|
        [date, rtrs.group_by(&:hour)]
      end
    ]
  end

  # upserts a row
  def self.instantiate_rescue_time_raw_from_row row
    rtr = RescueTimeRaw.find_or_create_by(rt_date: row[0], rt_activity: row[3])
    rtr.update_attributes(
      #[Date Time Spent (seconds)   Number of People  Activity   Category   Productivity ]
      synced_at: Time.now,
      rt_date: row[0],
      rt_time_spent: row[1],
      rt_number_of_people: row[2],
      rt_activity: row[3],
      rt_category: row[4],
      rt_productivity: row[5]
    )
    rtr
    # rtr.sync_timezone
  end


end
