console.log 'REACT JS YEAA'
window.sp = {}
rd = React.DOM
{Route, Routes, DefaultRoute} = ReactRouter

Inbox = React.createClass
  render: ->
    rd.h4 null, 'Inbox'

Calendar = React.createClass
  render: ->
    rd.h4 null, 'Calendar'

Dashboard = React.createClass
  render: ->
    rd.h4 null, 'Dashboard'

sp.App = React.createClass
  render: ->
    rd.div null,
      rd.header null,
        rd.ul null,
          rd.li null,
            "hi"
          rd.li null,
            "hi"
          rd.li null,
            "hi"
        'logged in as sdf'
      @props.activeRouteHandler

routes = Routes location: 'history',
    Route name: 'app', path: '/activities', handler: sp.App,
      Route name: 'inbox', handler: Inbox
      Route name: 'calendar', handler: Calendar
      DefaultRoute handler: Dashboard







sp.ActivitiesComponent = React.createClass

  render: ->
    rd.h1 null, 'hello'

sp.ActivityComponent = React.createClass
  propTypes:
    activity: React.PropTypes.object.isRequired

  render: ->
    rd.div className: 'row',
      rd.div className: 'col-md-8',
        rd.ol null,
          rd.li null,
            "name: "
            @props.activity.name
          rd.li null,
            "category: "
            @props.activity.category
          rd.li null,
            "productivity: "
            @props.activity.productivity

$(document).ready ->
  props = window._sp_vars.props
  React.renderComponent(routes, document.body)

  # React.renderComponent sp.ActivityComponent(props), $('body')[0]


