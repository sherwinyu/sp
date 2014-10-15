class PagesController < ApplicationController
  respond_to :html

  def home
    @ember = true
    render layout: 'with_js'
  end

  def activities_component
    @react = true
    @react_props = Activity.first.as_j
    render layout: "with_react_js", template: 'pages/home'
  end

end
