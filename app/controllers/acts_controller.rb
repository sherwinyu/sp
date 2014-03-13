class ActsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @act = Act.new params[:act]
    @act.ended_at ||= @act.at + 1.hour
    @act.day ||= Day.on Util::DateTime.time_to_experienced_date @act.at
    if @act.save
      respond_with @act, status: :created
    else
      respond_with @act, status: 422
    end
  end

  def index
    @acts = Act.recent
    respond_with @acts
  end

  def show
    id = params[:id]
    respond_with @act
  end

  def update
    @act = Act.find params[:id]
    if @act.update_attributes params[:act]
      respond_with @act, status: :ok
    else
      respond_with @act, status: 422
    end
  end

end
