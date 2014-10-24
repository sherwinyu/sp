#= require utils/bs

window.sp = {}
rd = React.DOM

{Link, Route, Routes, DefaultRoute} = ReactRouter


sp.Activity = React.createClass

  _getState: ->
    req = $.get "/activities/#{@props.params.activityId}.json"
    req.done (response) =>
      @setState activity: response.activity

  componentDidMount: ->
    @_getState()

  componentWillReceiveProps: (nextProps) ->
    if @props.params.activityId isnt nextProps.params.activityId
      @_getState()

  getInitialState: ->
    activity: null

  render: ->
    console.log @state.activity
    if @state.activity
      rd.div null,
        rd.h2 null, @state.activity.name
        rd.h6 null, "activity... #{@props.params.activityId}"
        rd.form null,
          bs.FormGroup null,
            bs.Label null,
              'Name'
            bs.FormInput value: @state.activity.name

          bs.FormGroup null,
            bs.Label null,
              'Productivity'
            bs.FormInput value: @state.activity.productivity


    else
      rd.h4 'loading...'





sp.ActivitiesIndex = React.createClass

  propTypes:
    mostUsedActivities: React.PropTypes.array.isRequired

  render: ->
    rd.div className: 'container',
      rd.h1 null, 'SP Activities'
      bs.Row null,
        bs.Col sm: 6,
          @renderActivities()
        bs.Col sm: 6,
          @props.activeRouteHandler()

  renderActivities: ->
    rd.div className: 'activities',
      rd.h2 null,
        'Most recent'
      for activity in @props.mostUsedActivities
        rd.div className: 'activity-summary',
          rd.span null,
            Link  to: 'activity', params: {activityId: activity.id},
              activity.name
          rd.span null,
            activity.duration




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
