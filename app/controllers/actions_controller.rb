class ActionsController < ApplicationController
  respond_to :html, :json
  
  def new
  end

  def create
  end

  def index
    @actions = Action.all
    respond_with @actions
  end

  def show
    #@pom = Pom.find params[:id]
    #respond_with @pom
  end
end
