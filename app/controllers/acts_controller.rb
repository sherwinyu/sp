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
    detail = params[:act].delete :detail
    ret = @act.update_attributes params[:act]
    detail = {val: detail} if detail.class == Array
    @act.create_detail detail
    puts ret, @act.inspect
    if ret
      respond_with @act, status: :ok
    else
      # TODO(syu): make sure that the client can actually process these errors and that the code is correct
      # respond_with status: 500
      respond_with @act, status: 422 #render text: @act.to_json, status: 422
    end
  end

end
