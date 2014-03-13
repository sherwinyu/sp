require 'spec_helper'

describe Act do
  describe "::recent" do
    before(:each) do
      day = Day.create(date: Date.new(2014, 1, 1))

      # Create 11 acts
      @first = create :act, day: day
      9.times do
        create :act, day: day
      end
      @last = create :act, day: day, at: @first.at + 5.seconds
    end

    it "fetches 10 recent acts" do
      recent = Act.recent.to_a
      expect(recent).to have(10).items
    end
    it "returns the most recent first" do
      recent = Act.recent.to_a
      expect(recent.first).to eq @last
    end
  end
end
