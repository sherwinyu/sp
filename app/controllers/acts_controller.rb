class ActsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @act = Act.new act_params
    @act.ended_at ||= @act.at + 1.hour
    @act.day ||= Day.on Util::DateTime.dt_to_expd_date @act.at
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
    @act = Act.find params[:id]
    respond_with @act
  end

  def update
    @act = Act.find params[:id]
    if @act.update_attributes act_params
      respond_with @act, status: :ok
    else
      respond_with @act, status: 422
    end
  end

  private
    def act_params
      params.require(:act).permit(:at, :ended_at, :desc)
    end
end
