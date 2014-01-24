class PagesController < ApplicationController
  respond_to :html

  # skip_before_filter
  def home
    @ember = true
    render layout: 'with_js'
  end

  before_filter :authenticate_user!, only: :auth_required
  def auth_required
    render text: "successful"
  end

end
