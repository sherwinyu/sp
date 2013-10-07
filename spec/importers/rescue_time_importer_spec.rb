require 'spec_helper'

describe RescueTimeImporter do
  let(:json_response) {

  }
  describe "instantiate_from_raw_row" do
    context "insert" do
      it "creates a new RTR if nothing with the same rt_date and rt_activity exists"
      it "newly created RTRs have the proper activity, time spent, etc"
    end
    context "update" do
      it "does not create a new RTR"
    end
  end


end
