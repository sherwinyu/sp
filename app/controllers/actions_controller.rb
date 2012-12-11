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
    # convert gets for ids 1.. n to the appropriate action
    id = Action.all[Integer(id) - 1].id if Integer(id) rescue id
    @action = Action.find id
    respond_with @action
  end

  def update
    @action = Action.find params[:id]
    binding.pry
  end
end
