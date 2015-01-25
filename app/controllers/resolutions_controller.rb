class ResolutionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_props
  respond_to :json

  def prepare_props
    @react_props = Activity.first.as_j
    @react_props = {
        activities: ActiveModel::ArraySerializer.new(Activity.recent).as_json
    }
  end

  def create
  end

  def index
    @resolutions = Resolution.all
    respond_to do |format|
      format.html { render layout: 'with_react_js', template: 'pages/home' }
      format.json { render json: @resolutions}
    end
  end

  def update
    @activity = Activity.find params[:id]
    if @activity.update_attributes activity_params
      render json: nil, status: :no_content
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def activity_params
    p = params.require(:activity).permit(
      :name,
      :category,
      :productivity
    )
    p
  end

end
