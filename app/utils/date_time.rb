class Util
  def self.format_as_rt_date(time)
    time.strftime("%Y-%m-%dT%H:%M:%S")
  end

  # Precondition: time_string is of rt_date format
  # returns: a time in UTC.
  def self.convert_to_absolute_time time_string
    # Grab the time string
    time = Time.parse(time_string)

    # Get the time zone
    tz = TZInfo::Timezone.get('US/Eastern')

    # tz.local_to_utc ignores timezones, instead; treates
    # argument as if it were local time in tz
    tz.local_to_utc(time)
  end

end
