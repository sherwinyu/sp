require 'spec_helper'

describe LastFmImporter do
  describe ".time_start" do
    it "returns the time stamp of the latest LastFmDp" do
      lfmdp = LastFmDp.new at: Time.new( 2013, 3, 2)
      LastFmDp.stub(:latest).and_return lfmdp
      LastFmImporter.time_start.should eq lfmdp.at
    end
    it "returns 1-hour-ago when no LastFmDps exist" do
      LastFmDp.stub(:latest).and_return nil
      LastFmImporter.time_start.should be_within(2).of Time.now - 1.hour
    end
  end
  describe ".time_end" do
    it "returns Time.now" do
      LastFmImporter.time_end.should be_within(2).of Time.now
    end
  end
end

