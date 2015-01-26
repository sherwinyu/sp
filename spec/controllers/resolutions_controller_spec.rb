require 'spec_helper'

describe ResolutionsController do
  before :each do
    setup
  end

  let :user do
    create :user
  end

  let :resolution_params do
    {
      format: :json,
      resolution: {
        text: 'Commit by 5pm',
        group: 'Sherwin Sundays',
        frequency: 'weekly',
        type: 'resolution'
      }
    }
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "api#create" do
    it 'creates a resolution' do
      post :create, resolution_params
      resolution = Resolution.last
      expect(resolution.text).to eq 'Commit by 5pm'
    end
  end

  describe "api#update" do
  end

  describe "api#show" do
  end

  # describe "api#index" do
  #   it "returns 200" do
  #     get :index, format: :json
  #     response.status.should eq 200
  #   end

  #   it "fetches recent acts" do
  #     Day.should_receive :recent
  #     get :index, format: :json
  #   end
  # end

  # describe "authentication" do
  #   before(:each) { sign_out user }
  #   specify "is required" do
  #     get :index, format: :json
  #     response.status.should eq 401

  #     post :create, format: :json
  #     response.status.should eq 401

  #     get :show, format: :json, id: 1
  #     response.status.should eq 401

  #     put :update, format: :json, id: 1
  #     response.status.should eq 401
  #   end
  # end
end
