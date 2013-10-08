require 'spec_helper'
describe "Util: date time" do
  let(:time_string) { "2013-10-08T11:07:08" }

  it "has the correct format for locally parsed times" do
    time = Time.parse time_string
    Util.format_as_rt_date(time).should eq "2013-10-08T11:07:08"
  end

  it "ignores time zone information (displays as if it  were in local time)" do
    time = Time.parse time_string + " UTC"
    tz = TZInfo::Timezone.get("US/Eastern")
    time = tz.local_to_utc(time)
    # time is now 2013-10-08T11:07:08 -04:00" (parsed time_string as if it were in Eastern"
    # also equivalent to 2013-10-08T15:07:08 +00:00 (UTC)
    Util.format_as_rt_date(time).should eq "2013-10-08T15:07:08"
  end
end

