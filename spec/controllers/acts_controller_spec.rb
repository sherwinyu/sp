require 'spec_helper'

describe ActsController do
  let(:valid_attributes) do
    { 
      description: "some_description",
      detail: {
        a: 5
      }


    }
  end

  describe "PUT update" do
    it "should derp" do
      act = Act.create! valid_attributes
      Act.any_instance.should_receive(:update_attributes).with "description"=> "some_description"
      put :update, id: act.to_param, act: {description: 'some_description'}
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
        detail: { a: 5, },
         #duration: nil,
        start_time: nil,
        end_time: nil,
        errors: {},
      }.to_json
      json["act"].to_json.should be_json_eql expected
    end

    it "should render associated detail" do
      request.accept = "application/json"
      act = Act.new valid_attributes
      d1 = act.detail
      d1[:zorgr] = [1,2,3]
      d1[:a] = 'a'
      act.save

      get :show, {id: act.to_param}, format: :json

      response.should be_success

      json = JSON.parse(response.body)
      expected = {
        id: act.to_param,
        description: 'some_description',
        detail:  {zorgr: [1,2,3], a: 'a'},
         #duration: nil,
        start_time: nil,
        end_time: nil,
        errors: {},
      }.to_json
      json["act"].to_json.should be_json_eql expected
    end
  end

end
