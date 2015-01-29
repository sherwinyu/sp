class ResolutionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_props
  respond_to :json

  def prepare_props
    @react_props = {
        activities: ActiveModel::ArraySerializer.new(Activity.recent).as_json
    }
  end

  def create
    @resolution = Resolution.new resolution_params
    if @resolution.save
      render json: @resolution, status: :created
    else
      render json: @resolution.errors, status: :unprocessable_entity
    end
  end

  def index
    @resolutions = Resolution.all
    respond_to do |format|
      format.html { render layout: 'with_react_js', template: 'pages/home' }
      format.json { render json: @resolutions}
    end
  end

  def update
    @resolution = Resolution.find params[:id]
    if @resolution.update_attributes resolution_params
      render json: @resolution
    else
      render json: @resolution.errors, status: :unprocessable_entity
    end
  end

  def resolution_params
    p = params.require(:resolution).permit(
      :text,
      :group,
      :frequency,
      :type
    )
    p
  end

end
