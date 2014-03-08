require 'spec_helper'

describe Act do
  describe "::recent" do
    it "fetches recent acts" do
      day = Day.create(date: Date.new(2014, 1, 1))
      first = create :act, day: day
      9.times do
        create :act, day: day
      end
      last = create :act, day: day, at: first.at + 5.seconds
      recent = Act.recent.to_a
      expect(recent).to have(10).items
      # check LIFO
      expect(recent.first).to eq last
    end
  end
end
