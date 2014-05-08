class RoutinesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    fail "not yet impl"
  end

  def show
    @routine = Routine.find params[:id]
  end

  def index
    @routines = Routine.all
    respond_with @routines
  end
end
