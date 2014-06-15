require 'spec_helper'

describe DaysController do
  let :user do
    create :user
  end
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "api#create" do
  end
  describe "api#update" do
  end

  describe "api#show" do
  end

  describe "api#index" do
    it "returns 200" do
      get :index, format: :json
      response.status.should eq 200
    end

    it "fetches recent acts" do
      Day.should_receive :recent
      get :index, format: :json
    end
  end

  describe "authentication" do
    before(:each) { sign_out user }
    specify "is required" do
      get :index, format: :json
      response.status.should eq 401

      post :create, format: :json
      response.status.should eq 401

      get :show, format: :json, id: 1
      response.status.should eq 401

      put :update, format: :json, id: 1
      response.status.should eq 401
    end
  end
end
