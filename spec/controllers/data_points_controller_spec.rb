require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

=begin
DataPointsController do

  # This should return the minimal set of attributes required to create a valid
  # DataPoint. As you add validations to DataPoint, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "submitted_at" => "2013-09-02 22:55:05" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DataPointsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all data_points as @data_points" do
      data_point = DataPoint.create! valid_attributes
      get :index, {}, valid_session
      assigns(:data_points).should eq([data_point])
    end
  end

  describe "GET show" do
    it "assigns the requested data_point as @data_point" do
      data_point = DataPoint.create! valid_attributes
      get :show, {:id => data_point.to_param}, valid_session
      assigns(:data_point).should eq(data_point)
    end
  end

  describe "GET new" do
    it "assigns a new data_point as @data_point" do
      get :new, {}, valid_session
      assigns(:data_point).should be_a_new(DataPoint)
    end
  end

  describe "GET edit" do
    it "assigns the requested data_point as @data_point" do
      data_point = DataPoint.create! valid_attributes
      get :edit, {:id => data_point.to_param}, valid_session
      assigns(:data_point).should eq(data_point)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DataPoint" do
        expect {
          post :create, {:data_point => valid_attributes}, valid_session
        }.to change(DataPoint, :count).by(1)
      end

      it "assigns a newly created data_point as @data_point" do
        post :create, {:data_point => valid_attributes}, valid_session
        assigns(:data_point).should be_a(DataPoint)
        assigns(:data_point).should be_persisted
      end

      it "redirects to the created data_point" do
        post :create, {:data_point => valid_attributes}, valid_session
        response.should redirect_to(DataPoint.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved data_point as @data_point" do
        # Trigger the behavior that occurs when invalid params are submitted
        DataPoint.any_instance.stub(:save).and_return(false)
        post :create, {:data_point => { "submitted_at" => "invalid value" }}, valid_session
        assigns(:data_point).should be_a_new(DataPoint)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DataPoint.any_instance.stub(:save).and_return(false)
        post :create, {:data_point => { "submitted_at" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested data_point" do
        data_point = DataPoint.create! valid_attributes
        # Assuming there are no other data_points in the database, this
        # specifies that the DataPoint created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DataPoint.any_instance.should_receive(:update_attributes).with({ "submitted_at" => "2013-09-02 22:55:05" })
        put :update, {:id => data_point.to_param, :data_point => { "submitted_at" => "2013-09-02 22:55:05" }}, valid_session
      end

      it "assigns the requested data_point as @data_point" do
        data_point = DataPoint.create! valid_attributes
        put :update, {:id => data_point.to_param, :data_point => valid_attributes}, valid_session
        assigns(:data_point).should eq(data_point)
      end

      it "redirects to the data_point" do
        data_point = DataPoint.create! valid_attributes
        put :update, {:id => data_point.to_param, :data_point => valid_attributes}, valid_session
        response.should redirect_to(data_point)
      end
    end

    describe "with invalid params" do
      it "assigns the data_point as @data_point" do
        data_point = DataPoint.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataPoint.any_instance.stub(:save).and_return(false)
        put :update, {:id => data_point.to_param, :data_point => { "submitted_at" => "invalid value" }}, valid_session
        assigns(:data_point).should eq(data_point)
      end

      it "re-renders the 'edit' template" do
        data_point = DataPoint.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DataPoint.any_instance.stub(:save).and_return(false)
        put :update, {:id => data_point.to_param, :data_point => { "submitted_at" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested data_point" do
      data_point = DataPoint.create! valid_attributes
      expect {
        delete :destroy, {:id => data_point.to_param}, valid_session
      }.to change(DataPoint, :count).by(-1)
    end

    it "redirects to the data_points list" do
      data_point = DataPoint.create! valid_attributes
      delete :destroy, {:id => data_point.to_param}, valid_session
      response.should redirect_to(data_points_url)
    end
  end

end
=end
