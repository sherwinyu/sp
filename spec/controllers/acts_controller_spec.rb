require 'spec_helper'

describe ActsController do
  let(:valid_attributes) do
    {
      description: "hello world",
      at: Date.new(2014, 2, 7) + 5.hours
    }
  end

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
  end

  describe "must be authenticated" do
    before :each { sign_out user }
    it "requires authentication" do
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
