class RescueTimeImporter
  def self.run opts={}
    # TODO(syu): look up latest RTRaw and use that as the time stamp boundary
    range = opts[:range] || (Time.now - 1.day)..(Time.now)
    rtrs = RescueTimeRaw.import(range)
    rtdps = RescueTimeDp.upsert_from_rescue_time_raws(rtrs)
  end
  # upserts a row
  def self.instantiate_rescue_time_raw_from_row row
    rtr = RescueTimeRaw.find_or_create_by(rt_date: row[0], rt_activity: row[3])
    rtr.update_attributes(
      #[Date Time Spent (seconds)   Number of People  Activity   Category   Productivity ]
      synced_at: Time.now,
      date: nil,

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
