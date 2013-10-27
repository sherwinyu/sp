class SpDaysController < ApplicationController
  respond_to :html, :json

  def index
    @sp_days  = SpDay.all
    respond_with @sp_days
  end

  def show
    @sp_day = SpDay.find(params[:id])

    if @sp_day
      render json: @sp_day
    else
      render json: @sp_day, status: 404
    end
  end

end

