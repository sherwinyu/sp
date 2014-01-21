require 'spec_helper'

describe DataPointsController do
  describe "#index (integration)" do
    it "includes the _type field" do
      lfmdp = LastFmDp.create at: Time.now - 10.seconds, name: "track1"
      dp = DataPoint.create at: Time.now, details: {hello: "world"}
      get :index, format: :json
      json = JSON.parse response.body
      expect(json["data_points"][0]["_type"]).to eq "DataPoint"
      expect(json["data_points"][1]["_type"]).to eq "LastFmDp"
    end
    context "when LastFmDps are included in recent" do

      it "assigns the @data_points" do
        lfmdp = LastFmDp.create at: Time.now, name: "track1"
        dp = DataPoint.create at: Time.now, details: {hello: "world"}
        get :index, format: :json
        expect(assigns(:data_points)).to include lfmdp
        expect(assigns(:data_points)).to include dp
      end

      it "includes the lfm in the json response" do
        lfmdp = LastFmDp.create at: Time.now, name: "track1"
        dp = DataPoint.create at: Time.now, details: {hello: "world"}
        get :index, format: :json
        json = JSON.parse response.body
        expect(json["data_points"][0]).to have_key "details"
        expect(json["data_points"][1]).to have_key "details"
        expect(json["data_points"][1]["details"]["name"]). to eq "track1"
      end
    end
  end
end
=begin
 ActsController do
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
=end
