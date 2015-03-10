require 'spec_helper'

describe Day do
  before :each do
    setup
  end

  describe "custom id" do
    let (:day) { Day.new note: "first" }
    let (:day2) { Day.new note: "first" }

    it "only allows one day with a given id" do
      day.save!
      day2.save.should eq false
    end

    it "supports find by a Date object" do
      day.save!
      found = Day.find_by date: Date.current
      found.should eq day
    end

    it "defaults to Date.today" do
      expect(day.date).to eq Date.current
    end
  end
  describe '#new' do
    let (:day) { Day.new note: 'first' }
    it 'has a default date' do
      expect(day.date).to eq Date.current
    end
    it 'has a default start_at' do
      time_4am = ActiveSupport::TimeZone.new(Option.current_timezone).parse "#{day.date} 04:00"
      expect(day.start_at).to eq time_4am
    end
  end

  pending "latest" do
    let (:sunday) { Date.new(2013, 10, 27) }
    let (:monday) { Date.new(2013, 10, 28) }
    let (:tuesday) { Date.new(2013, 10, 29) }

    let (:day_sunday) { Day.new _id: sunday, note: "sunday" }
    let (:day_monday) { Day.new _id: monday, note: "monday" }
    let (:day_tuesday) { Day.new _id: tuesday, note: "tuesday" }

    let (:sunday_evening) { sunday.to_time + 18.hours }
    let (:monday_dawn) { monday.to_time + 4.hours }
    let (:monday_morning) { monday.to_time + 9.hours }
    let (:tuesday_dawn) { tuesday.to_time + 4.hours }
    before :each do
      Time.stub(:now).and_return current_time
    end

    context "when current time matches an existing day" do
      before(:each) {day_sunday.save!}

      context "in the evening" do
        let (:current_time) { sunday_evening }
        it "returns the matching day" do
          Day.latest.should eq day_sunday
        end
      end
      context "next day morning" do
        let (:current_time) { monday_dawn }
        it "returns the matching day" do
          Day.latest.should eq day_sunday
        end
      end
    end

    context "when current time is one day ahead (on a new day)" do
      before (:each) {day_sunday.save!}

      context "in the morning of the new day" do
        let (:current_time) { monday_morning }
        it "creates and returns a new Day matching the date" do
          expect{latest = Day.latest}.to change{Day.count}.by 1
          latest.id.should eq monday
          latest.should be_persisted
        end
      end
      context "up to the dawn of the day after the new day" do
        let (:current_time) { tuesday_dawn }
        it "creates and returns a new Day matching the date" do
          expect{latest = Day.latest}.to change{Day.count}.by 1
          latest.id.should eq monday
          latest.should be_persisted
        end
      end
    end

    context "when current time is multiple days ahead" do
      it "creates and returns a new Day maching the date"
      it "doesn't do anything else"
    end

    context "current time is more than one day behind" do
      let (:current_time) { monday_morning }
      before(:each) do
        day_sunday.save!
        day_monday.save!
        day_tuesday.save!
      end
      it "throws an error" do
        expect{Day.latest}.to raise_error
      end
    end

  end
end
