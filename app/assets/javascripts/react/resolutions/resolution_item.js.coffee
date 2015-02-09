React = require 'react'

ResolutionActions = require 'react/resolutions/resolution_actions'
DateTimePicker = require 'react_components/date_time_picker'
bs = require 'utils/bs'
rd = React.DOM

ResolutionItem = React.createClass
  displayName: 'ResolutionItem'

  propTypes:
    resolution: React.PropTypes.shape(
      id: React.PropTypes.string.isRequired
      text: React.PropTypes.string.isRequired
      completions: React.PropTypes.arrayOf(React.PropTypes.shape(
        ts: React.PropTypes.instanceOf moment
        comment: React.PropTypes.string
      )).isRequired
      trackFrequency: React.PropTypes.string
      routine: React.PropTypes.object
      type: React.PropTypes.string
      currentCount: React.PropTypes.number
      targetCount: React.PropTypes.number
      doneInInterval: React.PropTypes.boolean
    )

  statics:
    UI_STATES:
      'COLLAPSED': 'COLLAPSED'
      'EXPANDED': 'EXPANDED'
      'EDITING': 'EDITING'
      'SAVING': 'SAVING'

  expanded: -> @state.ui == ResolutionItem.UI_STATES.EXPANDED
  collapsed: -> @state.ui == ResolutionItem.UI_STATES.COLLAPSED
  saving: -> @state.ui == ResolutionItem.UI_STATES.SAVING
  editing: -> @state.ui == ResolutionItem.UI_STATES.EDITING

  # TODO separate collapsed state from editing state
  toggleExpand: ->
    if @collapsed()
      @setState ui: ResolutionItem.UI_STATES.EXPANDED
    if @expanded()
      @setState ui: ResolutionItem.UI_STATES.COLLAPSED

  edit: (e) ->
    e.stopPropagation()
    @setState ui: ResolutionItem.UI_STATES.EDITING

  getInitialState: ->
    ui: ResolutionItem.UI_STATES.COLLAPSED
    resolution: @props.resolution

  saveResolution: ->
    @setState ui: ResolutionItem.UI_STATES.SAVING
    ResolutionActions.updateResolution @props.resolution.id, @state.resolution
      .done => @setState ui: ResolutionItem.UI_STATES.EXPANDED

  _resolutionLinkState: (key) ->
    return {
      value: @state.resolution[key]
      requestChange: (newValue) =>
        newResolution = React.addons.update @state.resolution, _.object([key], [{$set: newValue}])
        @setState {resolution: newResolution}
        return
    }

  renderCollapsed: ->
    resolution = @props.resolution
    null

  trackCompletion: ->
    ts = @refs.completionDateTime.getValue()

    completion =
      comment: @refs.completionComment.getDOMNode().value
      ts: ts
      day: ts.format('YYYY-MM-DD')
    ResolutionActions.createCompletion @props.resolution.id, completion

  _renderCompletions: (completions) ->
    rd.ul null,
      for completion in completions
        rd.li null,
          rd.p null,
            completion.comment
          rd.p className: 'u-tiny-text faded',
            rd.a href: "/#/days/#{completion.date}",
              completion.ts.calendar()

  renderTrackingWidget: ->
    rd.div className: 'input-group u-small-spacing-bottom',
      rd.span className: 'input-group-btn',
        rd.button
          className: 'btn btn-default',
          onClick: @trackCompletion
        , 'Track'
      DateTimePicker ref: 'completionDateTime'
      bs.FormInput
        ref: 'completionComment'
        style: {width: '78%'}
        className: 'u-z-up1 u-pos-relative'
        placeholder: 'Leave a comment'

  renderExpanded: ->
    resolution = @props.resolution
    rd.div null,
      @renderTrackingWidget()
      @_renderCompletions resolution.completions


  renderEditing: ->
    resolution = @props.resolution
    bs.FormGroup null,
      bs.Label null,
        'Text'
      bs.FormInput
        valueLink: @_resolutionLinkState 'text'
      bs.Label null,
        'Group'
      bs.FormInput
        valueLink: @_resolutionLinkState 'group'
      bs.Label null,
        'Target count'
      bs.FormInput
        valueLink: @_resolutionLinkState 'targetCount'
      if @editing()
        rd.button
          className: 'btn btn-success btn-sm u-tiny-spacing-top'
          onClick: @saveResolution
        , 'Save'
      if @saving()
        rd.button
          className: 'btn btn-success btn-sm u-tiny-spacing-top'
          disabled: true
        , 'Saving'

  renderNumberCompleted: ->
    if @props.resolution.targetCount?
      "#{@props.resolution.currentCount}/#{@props.resolution.targetCount}"
    else
      "#{@props.resolution.currentCount} completed"

  render: ->
    rd.li className: 'list-group-item',
      rd.a className: 'u-pointer', onClick: @toggleExpand,
        rd.h4 className: 'u-display-inline',
          @props.resolution.text
        rd.span className: 'faded u-cursor',
          " #{@props.resolution.currentCount}/#{@props.resolution.targetCount}"
      if @expanded()
        rd.div className: 'u-small-spacing-bottom',
          rd.button
            className: 'btn btn-default btn-sm'
            onClick: @edit
          , 'Edit'
          rd.button
            className: 'btn btn-default btn-sm u-small-spacing-left'
            onClick: null
          , 'More...'
      if @collapsed()
        @renderCollapsed()
      if @expanded()
        @renderExpanded()
      if @editing() or @saving()
        @renderEditing()

          # bs.Col sm: 5,
          #   if currentCount? and targetCount?
          #     rd.div className: 'progress',
          #       rd.div
          #         className: 'progress-bar'
          #         'aria-valuemin': 0
          #         'aria-valuenow': currentCount
          #         'aria-valuemax': targetCount
          #         style:
          #           width: "#{currentCount/ targetCount * 100}%"
          #       ,
          #         "#{currentCount}/#{targetCount}"

module.exports = ResolutionItem
