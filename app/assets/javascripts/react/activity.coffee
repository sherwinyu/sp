React = require 'react'
ReactRouter = require 'react-router'
bs = require 'utils/bs'
util = require 'utils/helpers'

rd = React.DOM
update = React.addons.update
{Link, RouteHandler} = ReactRouter

Activity = React.createClass

  mixins: [ReactRouter.State]

  _getState: (activityId = @getParams().activityId) ->
    activityId ?= @getParams().activityId
    req = $.get "/activities/#{activityId}.json"
    req.done (response) =>
      @setState activity: response.activity

  componentDidMount: ->
    @_getState()

  componentWillReceiveProps: (nextProps) ->
    @_getState(@getParams().activityId)

  getInitialState: (e) ->
    activity: null

  updateActivityProperty: (property, e) ->
    merge = {}
    merge[property] = e.target.value
    @setState activity: update(@state.activity, $merge: merge)

  save: ->
    req = $.putJSON "/activities/#{@getParams().activityId}.json",
      activity: @state.activity
    req.done (response) =>
      @props.addNotification "Successfully updated activity #{@state.activity.name}"
    .fail (error) =>
      @props.addNotification "Something went wrong! #{@error}"

  render: ->
    if @state.activity
      rd.div null,
        rd.h2 null, @state.activity.name
        rd.h6 null,  "activity... #{@getParams().activityId}"
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
              "Duration (#{util.sToDurationString @state.activity.duration})"
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

ActivitiesIndex = React.createClass

  propTypes:
    mostUsedActivities: React.PropTypes.array.isRequired

  getDefaultProps: ->
    mostUsedActivities: window._sp_vars.props.activities

  render: ->
    rd.div className: 'container',
      rd.h1 null, 'SP Activities'
      bs.Row null,
        rd.nav className: 'navbar navbar-default', role: 'navigation',
          rd.div className: 'collapse navbar-collapse',
            rd.form className: 'navbar-form navbar-left', role: 'search',
              bs.FormGroup null,
                bs.FormInput
                  placeHolder: 'Search Activities'
                  type: 'text'
              rd.button type: 'submit', className: 'btn btn-default',
                'Go'

      bs.Row null,
        bs.Col sm: 3,
          @renderActivities()
        bs.Col sm: 9,
          RouteHandler addNotification: @props.addNotification

  renderActivities: ->
    rd.div className: 'activities',
      rd.h2 null,
        'Most recent'
      for activity in @props.mostUsedActivities
        rd.div className: 'activity-summary', key: activity.id,
          rd.span null,
            Link to: 'activity', params: {activityId: activity.id},
              activity.name
          rd.span null,
            utils.sToDurationString activity.duration

module.exports = {
  Activity
  ActivitiesIndex
}
