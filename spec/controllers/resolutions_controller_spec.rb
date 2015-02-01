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

  describe 'api#track_resolution_completion' do
    let (:existing_resolution) { Resolution.create text: 'r1' }

    let (:resolution_completion_params) do
      {
        resolution_completion: {
          comment: 'This is a comment'
        },
        id: existing_resolution.id,
        format: :json
      }
    end

    it 'creates a resolution_completion for the proper resolution' do
      post :create_resolution_completion, resolution_completion_params
      expect(existing_resolution.reload.completions).to have(1).element
    end

    it 'returns the newly created completion' do
      post :create_resolution_completion, resolution_completion_params
      json = Hashie::Mash.new(JSON.parse response.body).completion
      expect(json.comment).to eq 'This is a comment'
      expect(json.ts).to_not be_nil
    end

    it 'returns the updated resolution' do
      post :create_resolution_completion, resolution_completion_params
      json = Hashie::Mash.new(JSON.parse response.body).resolution
      expect(json.id).to eq existing_resolution.id.to_s
    end

    it 'defaults to saving the current timestamp' do
      fake_time = Time.zone.parse('2015-01-01 09:00:00')
      Time.stub(:current).and_return fake_time
      post :create_resolution_completion, resolution_completion_params

      json = Hashie::Mash.new(JSON.parse response.body).completion
      expect(json.ts).to eq '2015-01-01T09:00:00.000Z'
      expect(Time.zone.parse json.ts).to eq fake_time
      expect(existing_resolution.reload.completions[0]['ts']).to eq fake_time
    end
  end

  describe "api#show" do
  end

end
