require 'spec_helper'

describe RescueTimeImporter do
  let(:json_response) {

  }
  describe "instantiate_rescue_time_raw_from_row" do
    let (:row) {
      [
          "2013-10-07T17:00:00",
          5,
          1,
          "iTerm",
          "General Software Development",
          2
      ]
    }
    context "insert" do
      it "creates a new RTR if nothing with the same rt_date and rt_activity exists" do
        RescueTimeRaw.count.should eq 0
        rtr = RescueTimeImporter.instantiate_rescue_time_raw_from_row row
        RescueTimeRaw.count.should eq 1
        rtr.rt_activity.should eq "iTerm"
        rtr.rt_date.should eq "2013-10-07T17:00:00"

      end
      it "newly created RTRs have the proper activity, time spent, etc" do
        rtr = RescueTimeImporter.instantiate_rescue_time_raw_from_row row
        rtr.rt_activity.should eq "iTerm"
        rtr.activity.should eq "iTerm"

        rtr.rt_time_spent.should eq 5
        rtr.duration.should eq 5

        rtr.rt_category.should eq "General Software Development"
        rtr.category.should eq "General Software Development"

        rtr.experienced_time.should eq Time.parse "2013-10-07T17:00:00"
      end
    end
    context "update" do
      let (:existing) {
        create :rescue_time_raw, rt_date: row[0], rt_activity: row[3], rt_time_spent: 555
      }
      it "does not create a new RTR" do
        rtr = nil
        existing.rt_time_spent.should eq 555
        expect{rtr = RescueTimeImporter.instantiate_rescue_time_raw_from_row row}.not_to change {RescueTimeRaw.count}
        existing.reload.rt_time_spent.should eq 5
      end
    end
  end
  describe "rescue_time_api_query #integration" do

  end
  describe ".import" do
    it "accepts a time range parameter"
    it "calls rescue_time_api_query"
    it "calls instantiate_row for each row from the rescue time response"
    it "calls RescueTimeDp."
  end

  mon5p = "2013-10-07T17:00:00"
  mon6p = "2013-10-07T18:00:00"
  mon7p = "2013-10-07T19:00:00"
  tues6p = "2013-10-08T18:00:00"

  let(:rtrs) {
    [mon5p_video, mon5p_coding, mon6p_coding, mon7p_coding, tues6p_coding, tues6p_video]
  }
  let(:mon5p_video) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "video", rt_time_spent: 60}
  let(:mon5p_coding) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "coding", rt_time_spent: 60}

  let (:mon6p_coding) {create :rescue_time_raw, rt_date: mon6p, rt_activity: "coding", rt_time_spent: 60}
  let (:mon7p_coding) {create :rescue_time_raw, rt_date: mon7p, rt_activity: "lumping", rt_time_spent: 60}

  let (:tues6p_coding) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "coding", rt_time_spent: 60 }
  let (:tues6p_video) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "video", rt_time_spent: 60}

  describe "group_rtrs_by_date_and_hour" do

    let (:grouped) {RescueTimeImporter.group_rtrs_by_date_and_hour rtrs}
    it "combines by date and hour" do
      mon = Date.new(2013, 10, 7)
      tues = Date.new(2013, 10, 8)

      grouped.keys.should =~ [mon, tues]

      # grouped[mon] is a hash from hour to list of rtrs
      grouped[mon].values.flatten.should have(4).rtrs
      grouped[tues].values.flatten.should have(2).rtrs

      grouped[mon].keys.should =~ [17, 18, 19]
      grouped[mon][17].should =~ [mon5p_video, mon5p_coding]
      grouped[mon][18].should =~ [mon6p_coding]
      grouped[mon][19].should =~ [mon7p_coding]

      grouped[tues].keys.should =~ [18]
      grouped[tues][18].should =~ [tues6p_coding, tues6p_video]
    end

  end

  describe "activities_list_from_rtrs" do
    let (:rtrs) { [mon5p_video, mon5p_coding] }
    it "returns an array of {a: id, duration: time} objects" do
      activities = RescueTimeImporter.activities_list_from_rtrs rtrs

      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      activity2 = Activity.where(name: mon5p_coding.rt_activity).first

      expect(activity1).to_not be_nil
      expect(activity2).to_not be_nil

      expect(activities).to be_an Array
      expect(activities).to have(2).elements
      expect(activities[0]).to eq( {a: activity1.id, duration: mon5p_video.duration} )
      expect(activities[1]).to eq( {a: activity2.id, duration: mon5p_coding.duration} )
    end

  end
end
