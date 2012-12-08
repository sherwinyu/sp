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
    id = params[:id]
    if Integer(id)
      id = Action.all[Integer(id) - 1].id
    end
    @action = Action.find id
    #@pom = Pom.find params[:id]
    respond_with @action
  end
end
