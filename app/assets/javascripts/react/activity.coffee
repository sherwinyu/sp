#= require utils/bs
window.sp ||= {}
rd = React.DOM
update = React.addons.update
{Link, Route, Routes, DefaultRoute} = ReactRouter

sp.Activity = React.createClass

  _getState: (activityId = @props.params.activityId) ->
    req = $.get "/activities/#{activityId}.json"
    req.done (response) =>
      @setState activity: response.activity

  componentDidMount: ->
    @_getState()

  componentWillReceiveProps: (nextProps) ->
    if @props.params.activityId isnt nextProps.params.activityId
      @_getState(nextProps.params.activityId)

  getInitialState: (e) ->
    activity: null

  updateActivityProperty: (property, e) ->
    merge = {}
    merge[property] = e.target.value
    @setState activity: update(@state.activity, $merge: merge)

  save: ->
    req = $.putJSON "/activities/#{@props.params.activityId}.json",
      activity: @state.activity
    req.done (response) =>
      @props.addNotification "Successfully updated activity #{@state.activity.name}"
    .fail (error) =>
      @props.addNotification "Something went wrong! #{@error}"

  render: ->
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
              onChange: @updateActivityProperty.bind null, 'name'

          bs.FormGroup null,
            bs.Label null,
              'Productivity'
            bs.FormInput
              value: @state.activity.productivity
              onChange: @updateActivityProperty.bind null, 'productivity'

          bs.FormGroup null,
            bs.Label null,
              "Duration (#{utils.sToDurationString @state.activity.duration})"
            bs.FormInput
              value: @state.activity.duration
              onChange: @updateActivityProperty.bind null, 'duration'

          bs.FormGroup null,
            bs.Label null,
              'Category'
            bs.FormInput
              value: @state.activity.category
              onChange: @updateActivityProperty.bind null, 'category'

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
        rd.div className: 'activity-summary', key: activity.id,
          rd.span null,
            Link  to: 'activity', params: {activityId: activity.id},
              activity.name
          rd.span null,
            utils.sToDurationString activity.duration
