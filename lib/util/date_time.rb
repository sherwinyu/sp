module Util
  class DateTime
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

    ##
    # @param [Time] an absolute time. (Regardless of timezone, seconds since epoch)
    # @return [Date] representing the "experienced day (in eastern time)" that time
    # coresponds to.
    #
    # E.g., 3am Tuesday in Eastern Time corresponds to Monday
    # Current cut off is 03:59:59 counts as previous day, 04:00:00 counts as current day
    def self.time_to_experienced_date time
      eastern_tz = TZInfo::Timezone.get('US/Eastern')
      eastern_time = time.in_time_zone(eastern_tz)
      experienced_date = eastern_time.to_date

      if eastern_time < experienced_date + 4.hours
        experienced_date = experienced_date.yesterday if eastern_time
      end
      experienced_date

    end

  end
end
