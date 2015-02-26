module Util
  class DateTime
    def self.tzi_tz
      TZInfo::Timezone.get timezone
    end

    def self.as_tz
      ActiveSupport::TimeZone.new timezone
    end

    def self.timezone
      Option.current_timezone
    end

    def self.format_as_rt_date(time)
      time.strftime("%Y-%m-%dT%H:%M:%S")
    end

    # Precondition: time_string is of rt_date format
    # returns: a time in UTC.
    def self.rt_time_to_absolute_time time_string
      # Grab the time string
      time = Time.parse(time_string)

      # current_timezone
      tz = TZInfo::Timezone.get(timezone)

      # tz.local_to_utc ignores timezones, instead; treats
      # argument as if it were local time in tz
      # Second argument says dst = true
      tz.local_to_utc(time, true)
    end

    # Timezone aware translation of a datetime to an experienced date
    # Re-expresses the given `datetime` in `timezone`, then looks at the
    # hour and compares it with day_starts_at.
    #
    # @param [DateTime or Time] representing a physical time. Its timezone is ignored
    # @param [String] timezone  a timezone that can be passed to `TimeZone.new`
    #   - defaults to Option.current_timezone
    # @param [Integer] day_starts_at  the hour threshold for counting when the new day starts
    # @return [Date] the experienced date corresponding to `datetime`
    #
    # So dt_to_expd_date(Tuesday, 2AM) will give the experienced date of Monday
    def self.dt_to_expd_date datetime, timezone=nil, day_starts_at=4
      timezone ||= Option.current_timezone
      tz = ActiveSupport::TimeZone.new timezone

      datetime = datetime.in_time_zone tz
      expd_date = datetime.to_date
      if datetime.hour < day_starts_at
        expd_date = expd_date.yesterday
      end
      expd_date
    end

    # Necessary to convert dates to datetimes while perserving the offset
    # WARNING: this MODIFIES the universaltime
    def self.d2dt date
      date.to_datetime.change offset: Time.zone.now.formatted_offset
    end

    ##
    # @param experienced_date -- the day to bias toward
    # @time A time. The date information is completely ignored. Timezone is respected
    #   the normalization (rolling back a day) decision is based on time.zone
    #
    # @return A datetime biased toward experienced_date, with the same timezone as time
    #
    # ed_and_time2dt
    def self.experienced_date_and_time_to_datetime experienced_date, time
      dt = d2dt experienced_date

      dt = dt.change(hour: time.hour, min: time.min, sec: time.sec)
      if dt.hour < 4
        dt = dt.in 1.day
      end
      dt
    end

    def day_normalize_time(time_or_datetime)
      if dt.hour < 4
        dt = dt.in 1.day
      end
    end

    def self.zoned time_or_datetime
      time_or_datetime.in_time_zone
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

    def self.currently_awake
      tz = ActiveSupport::TimeZone.new timezone
      t = tz.utc_to_local(Time.now.utc)
      (9..22).include? t.hour
    end

  end

end
