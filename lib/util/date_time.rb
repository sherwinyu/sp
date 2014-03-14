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


    # Necessary to convert dates to datetimes while perserving the offset
    # WARNING: this MODIFIES the universaltime
    def self.d2dt date
      date.to_datetime.change offset: Time.zone.now.formatted_offset
    end

    def self.experienced_date_and_time_to_datetime experienced_date, time
      dt = d2dt experienced_date

      dt = dt.change(hour: time.hour, min: time.min, sec: time.sec)
      if dt.hour < 4
        dt = dt.in 1.day
      end
      dt
    end

    def self.today_as_experienced_date
      datetime_to_experienced_date Time.now
    end

    def self.zoned time_or_datetime
      time_or_datetime.in_time_zone
    end

    def self.datetime_to_experienced_date datetime, day_starts_at=4
      dt = zoned datetime.to_datetime
      if dt.hour <  day_starts_at
        dt = dt.ago 1.day
      end
      dt.to_date
    end


    ##
    # @param arg [String | Date]
    # @return [Date]
    # Note that we don't support times, because of timezone issues!
    def self.to_date arg
      date = case arg
        when String
          raise "Expected #{arg} to match YYYY-MM-DD foramt" unless arg =~ /\d\d\d\d-\d\d?-\d\d?/
          Date.parse arg
        when Date
          arg
        else
          raise "Expected arg to be a string or a Date, instead got #{arg}: #{arg.class}"
        end
      return date
    end

  end
end
