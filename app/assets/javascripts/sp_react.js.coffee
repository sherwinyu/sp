window.sp = {}
rd = React.DOM
{Link, Route, Routes, DefaultRoute} = ReactRouter

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

$(document).ready ->
  props = window._sp_vars.props
  React.renderComponent(routes, $('.react-mount')[0])
