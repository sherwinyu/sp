require 'spec_helper'

describe ActsController do
  let(:valid_attributes) do
    { description: "some_description" }
  end

  describe "PUT update" do
    it "should derp" do
      binding.pry
      act = Act.create! valid_attributes
      Act.any_instance.should_receive(:update_attributes).with "description"=> "derp"
      put :update, id: act.to_param, act: {description: 'derp'}
    end
  end

  describe "GET show" do
    it "should render json" do
      request.accept = "application/json"
      act = Act.create! valid_attributes
      get :show, {id: act.to_param}, format: :json
      response.should be_success
      json = JSON.parse(response.body)
      expected = {
        id: act.to_param,
        description: "some_description",
        details: [],
        duration: nil,
        start_time: nil,
        end_time: nil,
        errors: {},
      }.to_json
      json["act"].to_json.should be_json_eql expected
    end

    it "should render associated details" do
      request.accept = "application/json"
      act = Act.new valid_attributes
      d1 = act.details.new 
      d1[:zorgr] = [1,2,3]
      d1[:a] = 'a'
      d2= act.details.new
      act.save

      get :show, {id: act.to_param}, format: :json

      response.should be_success

      json = JSON.parse(response.body)
      expected = {
        id: act.to_param,
        description: 'some_description',
        details: [ {zorgr: [1,2,3], a: 'a'},
          {} ],
        duration: nil,
        start_time: nil,
        end_time: nil,
        errors: {},
      }.to_json
      json["act"].to_json.should be_json_eql expected
    end
  end

end
