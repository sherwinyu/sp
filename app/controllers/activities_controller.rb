class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @activities = Activity.recent
    respond_with @activities
  end

  def show
    @activity = Activity.find params[:activity_id]
    binding.pry
    render json: @activity
  end

end
