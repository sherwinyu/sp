class ActsController < ApplicationController
  respond_to :html, :json

  def new
  end

  def create
  end

  def index
    @acts = Act.all
    respond_with @acts
  end

  def show
    id = params[:id]
    # convert gets for ids 1.. n to the appropriate act
    id = Act.all[Integer(id) - 1].id if Integer(id) rescue id
    @act = Act.find id
    respond_with @act
  end

  def update
    @act = Act.find params[:id]
    if @act.update_attributes params[:act]
      respond_with @act
    else
      # TODO(syu): make sure that the client can actually process these errors and that the code is correct
      respond_with @act.errors, status: :unprocessable_entity
    end
  end

end
