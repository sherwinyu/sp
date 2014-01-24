require 'spec_helper'

describe DataPointsController do
  describe "when not logged in" do
    it "index returns a 401 error" do
      get :index, format: :json
      expect(response.status).to eq 401
    end
  end
  describe "#index (integration)" do
    before :each do
      u = User.create email: "hello@example.com", password: 'password'
      sign_in u
    end
    it "includes the `type` field" do
      lfmdp = LastFmDp.create at: Time.now - 10.seconds, name: "track1"
      dp = DataPoint.create at: Time.now, details: {hello: "world"}
      get :index, format: :json
      json = JSON.parse response.body
      expect(json["data_points"][0]["type"]).to eq "DataPoint"
      expect(json["data_points"][1]["type"]).to eq "LastFmDp"
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
