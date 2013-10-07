class RescueTimeImporter
  def self.run opts={}
    # TODO(syu): look up latest RTRaw and use that as the time stamp boundary
    range = opts[:range] || (Time.now - 1.day)..(Time.now)
    rtrs = RescueTimeRaw.import(range)
    rtdps = RescueTimeDp.upsert_from_rescue_time_raws(rtrs)
  end
end
