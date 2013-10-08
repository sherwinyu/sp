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


end
