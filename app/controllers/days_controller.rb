class DaysController < ApplicationController
  respond_to :html, :json

  def index
    @latest_day = Day.latest

    if @latest_day.new_record?
      @latest_day.save
      @latest_day.note = "Just created"
    end

    respond_with [@latest_day]
    # @days  = Day.all
    # respond_with @days
  end

  def show
    @day = Day.find(params[:id])

    if @day
      render json: @day
    else
      render json: @day, status: 404
    end
  end

  def update
    @day = Day.find(params[:id])
    binding.pry
    if @day.update_attributes params[:day]
      render json: nil, status: :no_content
    else
      render json: @day.errors, status: :unprocessable_entity
    end
  end

end
