console.log 'REACT JS YEAA'
window.sp = {}
rd = React.DOM
sp.ActivitiesComponent = React.createClass
  render: ->
    rd.h1 null, 'hello'

$(document).ready ->
  React.renderComponent sp.ActivitiesComponent(null), $('body')[0]


