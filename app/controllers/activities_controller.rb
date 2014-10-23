class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_props
  respond_to :json

  def index
    @activities = Activity.recent
    respond_to do |format|
      format.html { render layout: 'with_react_js', template: 'pages/home' }
      format.json { render json: @activities }
    end
  end

  def prepare_props
    @react_props = Activity.first.as_j
    @react_props = {
        activities: ActiveModel::ArraySerializer.new(Activity.recent).as_json
    }
  end

  def show
    @activity = Activity.find params[:id]
    respond_to do |format|
      format.html { render layout: 'with_react_js', template: 'pages/home' }
      format.json { render json: @activity }
    end
  end

end
