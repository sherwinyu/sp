class SpDaysController < ApplicationController
  respond_to :html, :json

  def index
    @latest_sp_day = SpDay.latest

    if @latest_sp_day.new_record?
      @latest_sp_day.save
      @latest_sp_day.note = "Just created"
    end

    respond_with [@latest_sp_day]
    # @sp_days  = SpDay.all
    # respond_with @sp_days
  end

  def show
    @sp_day = SpDay.find(params[:id])

    if @sp_day
      render json: @sp_day
    else
      render json: @sp_day, status: 404
    end
  end

  def update
    @sp_day = SpDay.find(params[:id])
    binding.pry
    if @sp_day.update_attributes params[:sp_day]
      render json: nil, status: :no_content
    else
      render json: @sp_day.errors, status: :unprocessable_entity
    end
  end

end
