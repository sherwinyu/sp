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
      text: 'Commit by 5pm',
      group: 'Sherwin Sundays',
      frequency: 'weekly',
      type: 'resolution'
    }
  end

  let :params do
    {
      format: :json,
      resolution: resolution_params
    }
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "api#create" do
    it 'creates a resolution' do
      post :create, params
      resolution = Resolution.last
      expect(resolution.text).to eq 'Commit by 5pm'
    end
  end

  describe "api#index" do
    let (:resolutions) {
      r1 = Resolution.create text: 'r1'
      r2 = Resolution.create text: 'r2'
      r3 = Resolution.create text: 'r3'
      [r1, r2, r3]
    }

    before :each do
      resolutions
    end

    it 'lists all resolutions' do
      get :index, format: :json
      resolutions_json = Hashie::Mash.new(JSON.parse response.body).resolutions
      expect(resolutions_json[0].text).to eq 'r1'
      expect(resolutions_json[1].text).to eq 'r2'
      expect(resolutions_json[2].text).to eq 'r3'
    end
  end

  describe "api#update" do
    let (:existing_resolution) { Resolution.create text: 'r1' }

    let (:resolution_params) do
      {
        group: 'this is a group',
      }
    end
    let (:params) do
      {
        format: :json,
        resolution: resolution_params,
        id: existing_resolution.id
      }
    end

    it 'patches the attributes' do
      patch :update, params
      resolution = Resolution.find existing_resolution.id
      expect(resolution.text).to eq 'r1'
      expect(resolution.group).to eq 'this is a group'
    end

    it 'responds with the json of the resolution' do
      patch :update, params
      resolution_json = Hashie::Mash.new(JSON.parse response.body).resolution
      expect(resolution_json.group).to eq 'this is a group'
      expect(resolution_json.text).to eq 'r1'
    end
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
