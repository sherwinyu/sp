#= require utils/bs
window.sp ||= {}
rd = React.DOM
update = React.addons.update
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

  getInitialState: (e) ->
    activity: null

  updateName: (e) ->
    a = update @state.activity, $merge: {name: e.target.value}
    @setState activity: a

  updateProductivity: (e) ->
    a = update @state.activity, $merge: {productivity: e.target.value}
    @setState activity: a

  updateCategory: (e) ->
    a = update @state.activity, $merge: {name: e.target.value}
    @setState activity: a

  save: ->
    req = $.putJSON "/activities/#{@props.params.activityId}.json",
      activity: @state.activity
    req.done (response) =>
      @props.addNotification "Successfully updated activity #{@state.activity.name}"
    .fail (error) =>
      @props.addNotification "Something went wrong! #{@error}"

  render: ->
    console.log @state.activity
    if @state.activity
      rd.div null,
        rd.h2 null, @state.activity.name
        rd.h6 null,  "activity... #{@props.params.activityId}"
        rd.form null,

          bs.FormGroup null,
            bs.Label null,
              'Name'
            bs.FormInput
              value: @state.activity.name
              onChange: @updateName

          bs.FormGroup null,
            bs.Label null,
              'Productivity'
            bs.FormInput
              value: @state.activity.productivity
              onChange: @updateProductivity

          bs.FormGroup null,
            bs.Label null,
              'Category'
            bs.FormInput
              value: @state.activity.category
              onChange: @updateCategory

          rd.a
            className: 'btn btn-large btn-default'
            onClick: @save
          ,
            'Save'

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
          @props.activeRouteHandler
            addNotification: @props.addNotification

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
