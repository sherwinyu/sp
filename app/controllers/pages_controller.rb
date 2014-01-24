class PagesController < ApplicationController
  respond_to :html

  skip_before_filter :authenticate_user!
  def home
    @ember = true
    render layout: 'with_js'
  end

end
