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


  # POST /resolutions/resolution_completions
  def create_resolution_completion
    @resolution = Resolution.find params[:id]
    completion = {
      # TODO default to time.current, allow manual specify
      ts: Time.current ,
      comment: resolution_completion_params[:comment]
    }
    @resolution.completions << completion
    if @resolution.save
      render json: {completion: completion, resolution: @resolution.as_j(root: false)}
    else
      render json: @resolution.errors, status: :unprocessable_entity
    end
  end

  # PATCH /resolutions/resolution_completions/:id_timestamp
  def update_resolution_completion
    @resolution = Resolution.find params[:id]
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

  def resolution_completion_params
    params.require(:resolution_completion).permit!
  end

end
