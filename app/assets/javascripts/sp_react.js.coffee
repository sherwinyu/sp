
window.sp = {}
rd = React.DOM
{Link, Route, Routes, DefaultRoute} = ReactRouter

Inbox = React.createClass
  render: ->
    rd.h4 null, 'Inbox'

Calendar = React.createClass
  render: ->
    rd.h4 null, 'Calendar'

Dashboard = React.createClass
  render: ->
    rd.h4 null, 'Dashboard'

sp.Activities = React.createClass
  render: ->
    console.log @props.activeRouteHandler
    rd.div null,
      rd.h1 null, 'ACTIVITIES DASH'
      @props.activeRouteHandler

sp.Activity = React.createClass
  componentDidMount: ->
    $.ajax "/activities/#{@props.params.activityId}.json"

  render: ->
    rd.h1 null, "activity... #{@props.params.activityId}"


sp.ActivitiesIndex = React.createClass

  propTypes:
    mostUsedActivities: React.PropTypes.array.isRequired

  render: ->
    console.log @props.mostUsedActivities
    rd.div className: 'well',
      for activity in @props.mostUsedActivities
        rd.div className: 'activity-summary',
          rd.span null,
            Link  to: 'activity', params: {activityId: activity.id},
              activity.name
          rd.span null,
            activity.duration
      'wassup4'
      @props.activeRouteHandler()
      'wassup'

sp.App = React.createClass
  render: ->
    rd.div null,
      rd.header null,
        rd.ul null,
          rd.li null,
            'hi'
          rd.li null,
            'hi'
          rd.li null,
            'hi'
        'logged in as sdf'
      @props.activeRouteHandler

window.mostUsedActivities = [
  {
    id: 0
    name: 'warg'
    duration: 114
  }
  {
    id: 1
    name: 'dinosaur'
    duration: 33
  }
]
routes = Routes location: 'history',
    Route
      name: 'activities',
      path: '/activities',
      handler: sp.ActivitiesIndex,
      mostUsedActivities: window._sp_vars.props.activities
    ,
      Route
        name: 'activity'
        path: ':activityId'
        handler: sp.Activity







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
            'name: '
            @props.activity.name
          rd.li null,
            'category: '
            @props.activity.category
          rd.li null,
            'productivity: '
            @props.activity.productivity

$(document).ready ->
  props = window._sp_vars.props
  React.renderComponent(routes, $('.react-mount')[0])

  # React.renderComponent sp.ActivityComponent(props), $('body')[0]


