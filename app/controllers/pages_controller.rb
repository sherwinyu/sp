class PagesController < ApplicationController
  respond_to :html

  def home
    @ember = true
    render layout: 'with_ember_js'
  end

end
