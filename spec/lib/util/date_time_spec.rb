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

describe "Util: DateTime::timezone" do
  specify "read and write" do
    Option.current_timezone = "America/New_York"
    # Util::DateTime.timezone =
    expect(Util::DateTime.timezone).to eq "America/New_York"
  end

end

describe "Util: dt_to_expd_date" do
  let (:sunday) { Date.new(2013, 10, 27) }
  let (:monday) { Date.new(2013, 10, 28) }
  let (:tuesday) { Date.new(2013, 10, 29) }

  let (:sunday_dawn)    { tz.local_to_utc(sunday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:sunday_morning) { tz.local_to_utc(sunday.to_time) + 9.hours }
  let (:sunday_evening) { tz.local_to_utc(sunday.to_time) + 18.hours }

  let (:monday_dawn)    { tz.local_to_utc(monday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:monday_morning) { tz.local_to_utc(monday.to_time) + 9.hours }
  let (:monday_evening) { tz.local_to_utc(monday.to_time) + 18.hours }

  let (:tuesday_dawn)    { tz.local_to_utc(tuesday.to_time) + 3.hours + 59.minutes + 59.seconds }
  let (:tuesday_morning) { tz.local_to_utc(tuesday.to_time) + 9.hours }
  let (:tuesday_evening) { tz.local_to_utc(tuesday.to_time) + 18.hours }

  let (:tz) { ActiveSupport::TimeZone.new(tz_string)}

  before :each do
    Option.stub(:current_timezone).and_return(tz_string)
  end

  context "when in shanghai" do
    let (:tz_string) { 'Asia/Shanghai'}

    it "converts 3am to previous day" do
      Util::DateTime.dt_to_expd_date(monday_dawn).should eq sunday
      Util::DateTime.dt_to_expd_date(tuesday_dawn).should eq monday
    end

    it "converts 9am to current day" do
      binding.pry
      Util::DateTime.dt_to_expd_date(sunday_morning).should eq sunday
      Util::DateTime.dt_to_expd_date(monday_morning).should eq monday
      Util::DateTime.dt_to_expd_date(tuesday_morning).should eq tuesday
    end

    it "converts 9pm to current day" do
      Util::DateTime.dt_to_expd_date(sunday_evening).should eq sunday
      Util::DateTime.dt_to_expd_date(monday_evening).should eq monday
      Util::DateTime.dt_to_expd_date(tuesday_evening).should eq tuesday
    end
  end

  context "when in New York" do
    let (:tz_string) { 'America/New_York'}

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

end

describe "Util: to_date" do
  it "converts a valid string to a date" do
    arg = "2013-1-7"
    expect(Util::DateTime.to_date arg).to eq Date.new 2013, 1, 7
  end

  it "doesn't change an existing date" do
    arg = Date.new 2013, 1, 7
    expect(Util::DateTime.to_date arg).to eq arg
  end

  it "raises an error on a Time" do
    arg = Time.now
    expect{Util::DateTime.to_date arg}.to raise_error
  end
end

describe "rt_time_to_absolute_time" do
  # TODO(add more tests)
  context "when in New York" do
    it "returns the correct time" do
      # We're expectin `2014-01-28T10:00:00` to give us the same time, but in the new york time zone
      Option.stub(:current_timezone).and_return "America/New_York"
      tzny = ActiveSupport::TimeZone.new("America/New_York")
      expected_time = tzny.local_to_utc(DateTime.new(2014, 1, 28, 10, 0, 0))
      expect(Util::DateTime.rt_time_to_absolute_time "2014-01-28T10:00:00").to eq expected_time
    end
  end
  context "when in New York" do
    it "returns the correct time" do
      # We're expectin `2014-01-28T10:00:00` to give us the same time, but in the new york time zone
      Option.stub(:current_timezone).and_return "Asia/Shanghai"
      tzsh = ActiveSupport::TimeZone.new("Asia/Shanghai")
      expected_time = tzsh.local_to_utc(DateTime.new(2014, 1, 28, 10, 0, 0))
      expect(Util::DateTime.rt_time_to_absolute_time "2014-01-28T10:00:00").to eq expected_time
    end
  end
end
