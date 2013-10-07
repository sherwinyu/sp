class RescueTimeDp
  include Mongoid::Document
  include Mongoid::Timestamps
  field :date_time, type: Time
  field :activities

  def self.import
    # group by day (emitting a hash of date: [rtr]), then map those into
    # a [date, {hour: [rtrs]}]
    # then, the call to Hash[] converts the list of lists into list of
    # key value pairs
    grouped = Hash[
      RescueTimeRaw.all.group_by(&:day).map do |date, rtrs|
        [date, rtrs.group_by(&:hour)]
      end
    ]

    grouped.each do |date, hours|
      hours.each do |hour, rtrs|

        activities = {}
        rtrs.each do |rtr|
          activity = rtr.activity.gsub ".", "-"
          activities[activity] = {
            duration: rtr.duration,
            productivity: rtr.productivity,
            category: rtr.category
          }
        end
        rtdp = RescueTimeDp.create(
          date_time: rtrs.first.date,
          activities: activities
        )

      end
    end
  end

  def hour
    date_time.hour
  end

  def day
   date_time.to_date
  end

  def pretty_hour
    t1 = date_time
    t2 = date_time + 1.hour
    pm = t2.hour >= 12 ? "pm" : ""
    "#{t1.hour}:00-#{t2.hour}:00"
    "#{(t1.hour - 1) % 12 + 1}-#{(t2.hour - 1) % 12 + 1}#{pm}"
  end

  def next
    hour
  end

  def self.on_day date
    date = Date.parse(arg) if arg.class == String
    date1 = date
    date2 = date + 1.day
    self.where(:date_time => date1..date2)
  end
end
