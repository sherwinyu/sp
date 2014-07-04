class NotesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @notes = Note.all

    respond_with @notes
  end

  def show
    @note = Note.find params[:id]
    if @note
      render json: @note
    else
      render json: @note, status: 404
    end
  end

  private
end
