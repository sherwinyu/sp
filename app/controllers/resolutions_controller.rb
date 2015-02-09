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


  # POST /resolutions/:id/completions
  def create_completion
    @resolution = Resolution.find params[:id]
    ts = Time.current
    if completion_params[:ts]
      ts = Time.zone.parse completion_params[:ts]
    end


    completion_date = Date.strptime completion_params[:day], '%Y-%m-%d'
    day = Day.find_by date: completion_date

    completion = {
      # TODO default to time.current, allow manual specify
      ts: ts,
      comment: completion_params[:comment]
    }
    # TODO shift to using Resolution#add_completion and do the validations there
    completion[:day_id] = day.id if day
    completion[:date] = completion_params[:day]
    @resolution.completions << completion
    if @resolution.save
      render json: {completion: completion, resolution: @resolution.as_j(root: false)}
    else
      render json: @resolution.errors, status: :unprocessable_entity
    end

  rescue ArgumentError
    render json: @resolution.errors, status: :unprocessable_entity
  end

  # PATCH /resolutions/completions/:id_timestamp
  def update_completion
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

  def completion_params
    params.require(:completion).permit!
  end

end
