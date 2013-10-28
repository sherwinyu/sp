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

end
