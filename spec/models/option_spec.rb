require 'spec_helper'

describe Option do
  describe "::opts" do
    it "returns the first option if one exists" do
      o = Option.create()
      expect(Option.opts).to eq o
    end

    it "creates a new option if none exists" do
      expect(Option.count).to eq 0
      o = Option.opts
      expect(o).to be_instance_of Option
      expect(o).to be_persisted
    end
  end

  describe "::current_timezone" do
    it "fails when opts doesn't specify one" do
      expect{Option.current_timezone}.to raise_error
    end
    it "returns whatever is set on opt" do
      Option.create(current_timezone: "America/New_York")
      expect(Option.current_timezone).to eq "America/New_York"
    end
  end
end
