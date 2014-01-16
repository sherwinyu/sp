require 'spec_helper'
describe "Util: date time" do
  let(:time_string) { "2013-10-08T11:07:08" }

  it "has the correct format for locally parsed times" do
    time = Time.parse time_string
    Util::DateTime.format_as_rt_date(time).should eq "2013-10-08T11:07:08"
  end

  it "ignores time zone information (displays as if it  were in local time)" do
    time = Time.parse time_string + " UTC"
    tz = TZInfo::Timezone.get("US/Eastern")
    time = tz.local_to_utc(time)
    # time is now 2013-10-08T11:07:08 -04:00" (parsed time_string as if it were in Eastern"
    # also equivalent to 2013-10-08T15:07:08 +00:00 (UTC)
    Util::DateTime.format_as_rt_date(time).should eq "2013-10-08T15:07:08"
  end
end

describe "Util: time_to_experienced_date" do
  let (:sunday) { Date.new(2013, 10, 27) }
  let (:monday) { Date.new(2013, 10, 28) }
  let (:tuesday) { Date.new(2013, 10, 29) }
  let (:eastern_tz) { TZInfo::Timezone.get('US/Eastern') }

  let (:sunday_dawn)    { eastern_tz.local_to_utc(sunday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:sunday_morning) { eastern_tz.local_to_utc(sunday.to_time) + 9.hours }
  let (:sunday_evening) { eastern_tz.local_to_utc(sunday.to_time) + 18.hours }

  let (:monday_dawn)    { eastern_tz.local_to_utc(monday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:monday_morning) { eastern_tz.local_to_utc(monday.to_time) + 9.hours }
  let (:monday_evening) { eastern_tz.local_to_utc(monday.to_time) + 18.hours }

  let (:tuesday_dawn)    { eastern_tz.local_to_utc(tuesday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:tuesday_morning) { eastern_tz.local_to_utc(tuesday.to_time) + 9.hours }
  let (:tuesday_evening) { eastern_tz.local_to_utc(tuesday.to_time) + 18.hours }


  it "converts 3am to previous day" do
    Util::DateTime.time_to_experienced_date(monday_dawn).should eq sunday
    Util::DateTime.time_to_experienced_date(tuesday_dawn).should eq monday
  end

  it "converts 9am to current day" do
    Util::DateTime.time_to_experienced_date(sunday_morning).should eq sunday
    Util::DateTime.time_to_experienced_date(monday_morning).should eq monday
    Util::DateTime.time_to_experienced_date(tuesday_morning).should eq tuesday
  end

  it "converts 9pm to current day" do
    Util::DateTime.time_to_experienced_date(sunday_evening).should eq sunday
    Util::DateTime.time_to_experienced_date(monday_evening).should eq monday
    Util::DateTime.time_to_experienced_date(tuesday_evening).should eq tuesday
  end

end
