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
    ret = @act.update_attributes params[:act]
    binding.pry
    if ret
      respond_with @act
    else
      # TODO(syu): make sure that the client can actually process these errors and that the code is correct
      # respond_with status: 500
      render text: @act.errors.inspect, status: 403
    end
  end

end
