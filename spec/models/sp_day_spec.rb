require 'spec_helper'

describe SpDay do
  describe "custom id" do
    let (:sp_day) { SpDay.new note: "first" }
    let (:sp_day2) { SpDay.new note: "first" }

    it "only allows one day with a given id" do
      sp_day.save
      sp_day2.save.should eq false
    end

    it "supports find by a Date object" do
      sp_day.save
      found = SpDay.find(Date.today)
      found.should eq sp_day
    end

    it "defaults to Date.today" do
      sp_day.date.should eq Date.today
    end

  end

  describe "latest" do
    let (:sunday) { Date.new(2013, 10, 27) }
    let (:monday) { Date.new(2013, 10, 28) }
    let (:tuesday) { Date.new(2013, 10, 29) }

    let (:spd_sunday) { SpDay.new _id: sunday, note: "sunday" }
    let (:spd_monday) { SpDay.new _id: monday, note: "monday" }
    let (:spd_tuesday) { SpDay.new _id: tuesday, note: "tuesday" }

    let (:sunday_evening) { sunday.to_time + 18.hours }
    let (:monday_dawn) { monday.to_time + 4.hours }
    let (:monday_morning) { monday.to_time + 9.hours }
    let (:tuesday_dawn) { tuesday.to_time + 4.hours }
    before :each do
      Time.stub(:now).and_return current_time
    end

    context "when current time matches an existing day" do
      before(:each) {spd_sunday.save}

      context "in the evening" do
        let (:current_time) { sunday_evening }
        it "returns the matching day" do
          SpDay.latest.should eq spd_sunday
        end
      end
      context "next day morning" do
        let (:current_time) { monday_dawn }
        it "returns the matching day" do
          SpDay.latest.should eq spd_sunday
        end
      end
    end

    context "when current time is one day ahead (on a new day)" do
      before (:each) {spd_sunday.save}

      context "in the morning of the new day" do
        let (:current_time) { monday_morning }
        it "creates and returns a new SpDay matching the date" do
          expect{latest = SpDay.latest}.to change{SpDay.count}.by 1
          latest.id.should eq monday
          latest.should be_persisted
        end
      end
      context "up to the dawn of the day after the new day" do
        let (:current_time) { tuesday_dawn }
        it "creates and returns a new SpDay matching the date" do
          expect{latest = SpDay.latest}.to change{SpDay.count}.by 1
          latest.id.should eq monday
          latest.should be_persisted
        end
      end
    end

    context "when current time is multiple days ahead" do
      it "creates and returns a new SpDay maching the date"
      it "doesn't do anything else"
    end

    context "current time is more than one day behind" do
      let (:current_time) { monday_morning }
      before(:each) do
        spd_sunday.save
        spd_monday.save
        spd_tuesday.save
      end
      it "throws an error" do
        expect{SpDay.latest}.to raise_error
      end
    end

  end


end
