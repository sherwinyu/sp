React = require 'react'

ResolutionActions = require 'react/resolutions/resolution_actions'
DateTimePicker = require 'react_components/date_time_picker'
Select2 = require 'react_components/select2'
bs = require 'utils/bs'
utils = require 'utils/helpers'
rd = React.DOM

cx = React.addons.classSet

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
      frequency: React.PropTypes.string
      routine: React.PropTypes.object
      type: React.PropTypes.string
      currentCount: React.PropTypes.number
      targetCount: React.PropTypes.number
      doneInInterval: React.PropTypes.boolean
    )
    initialGroups: React.PropTypes.array.isRequired

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
    tracking: false
    ui: ResolutionItem.UI_STATES.COLLAPSED
    resolution: @props.resolution
    hover: false

  saveResolution: ->
    if @isMounted()
      @setState ui: ResolutionItem.UI_STATES.SAVING
    ResolutionActions.updateResolution @props.resolution.id, @state.resolution
      .done =>
        if @isMounted()
          @setState ui: ResolutionItem.UI_STATES.EXPANDED

  _resolutionLinkState: (key) ->
    return {
      value: @state.resolution[key]
      requestChange: (newValue) =>
        newResolution = React.addons.update @state.resolution, _.object([key], [{$set: newValue}])
        @setState {resolution: newResolution}
        return
    }

  trackCompletion: ->
    ts = @refs.completionDateTime.getValue()

    completion =
      comment: @refs.completionComment.getDOMNode().value
      ts: ts
    @setState tracking: true
    ResolutionActions.createCompletion @props.resolution.id, completion
      .done =>
        @setState tracking: false
        $(@refs.completionComment.getDOMNode()).val ''
        $(@refs.trackCompletion.getDOMNode()).blur()


  _renderCompletions: (completions) ->
    sampleCompletions = _.sortBy completions, (completion) -> -completion.ts.unix()
    sampleCompletions = _.take sampleCompletions, 5
    rd.ul null,
      for completion in sampleCompletions
        rd.li null,
          rd.p null,
            completion.comment
          rd.p className: 'u-tiny-text faded',
            rd.a href: "/#/days/#{completion.date}", title: completion.ts?.toString(),
              if completion.ts.isAfter moment().subtract(1, 'day')
                completion.ts.calendar()
              else
                utils.date.dateTimeToExperiencedDate(completion.ts).format 'YYYY-MM-DD'

  renderTrackingWidget: ->
    rd.div className: 'input-group u-small-spacing-bottom',
      rd.span className: 'input-group-btn',
        rd.button
          ref: 'trackCompletion'
          className: 'btn btn-default',
          onClick: @trackCompletion
          disabled: @state.tracking
        , 'Track'
      DateTimePicker ref: 'completionDateTime'
      bs.FormInput
        disabled: @state.tracking
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
    group = @state.resolution.group
    groups = @props.initialGroups.map (name) -> id: name, text: name
    unless group in @props.initialGroups
      groups.push id: group, text: group
    resolution = @props.resolution
    bs.FormGroup null,
      bs.Label null,
        'Text'
      bs.FormInput
        valueLink: @_resolutionLinkState 'text'
      bs.Label null,
        'Key'
      bs.FormInput
        valueLink: @_resolutionLinkState 'key'
      bs.Label null,
        'Group'
      Select2
        options: groups
        allowUserCreated: true
        value: @_resolutionLinkState('group').value
        onChange: @_resolutionLinkState('group').requestChange
      bs.Label null,
        'Target count'
      bs.FormInput
        key: 'count-input'
        valueLink: @_resolutionLinkState 'targetCount'
      bs.Label null,
        'Frequency'
      Select2
        options: [
          {id: 'daily', text: 'daily'}
          {id: 'weekly', text: 'weekly'}
          {id: 'weekend', text: 'weekend'}
          {id: 'monthly', text: 'monthly'}
        ]
        value: @_resolutionLinkState('frequency').value
        onChange: @_resolutionLinkState('frequency').requestChange
      rd.button
        key: 'save-button'
        className: 'btn btn-success btn-sm u-tiny-spacing-top'
        disabled: @saving()
        onClick: @saveResolution
      , if @saving() then 'Saving' else 'Save'

  isOverdue: ->
    durations =
      weekly: moment.duration(7, 'days')
      daily: moment.duration(1, 'days')
    {completions, frequency} = @props.resolution
    lastCompletedAt = completions[completions.length - 1]?.ts
    if not lastCompletedAt? or not frequency?
      return null
    late = lastCompletedAt.isBefore moment().subtract(durations[frequency])
    late

  renderBadge: ->
    {completions, frequency} = @props.resolution
    late = @isOverdue()
    classes = cx
      'label-default': not late
      'label-warning': late
    if frequency?
      rd.span
        className: "label u-tiny-spacing-left #{classes}"
        style:
          float: 'none'
          'font-weight': 'normal'
      ,
        frequency

  render: ->
    rd.li
      className: 'list-group-item'
      onMouseEnter: => @setState hover: true
      onMouseLeave: => @setState hover: false
    ,
      rd.a className: 'u-pointer', onClick: @toggleExpand,
        rd.h4 className: 'u-display-inline',
          @props.resolution.text
      if @isOverdue() or @state.hover or @expanded() or @editing()
        @renderBadge()
      if @state.hover or @expanded() or @editing()
        rd.span null,
          rd.span className: 'faded u-cursor pull-right',
            " #{@props.resolution.currentCount}/#{@props.resolution.targetCount}"
          rd.button
            className: 'btn btn-default btn-xs pull-right u-tiny-spacing-right'
          ,
            'Track'
      if @expanded()
        rd.div className: 'u-tiny-spacing-bottom',
          rd.button
            className: 'btn btn-default btn-sm'
            onClick: @edit
          , 'Edit'
          rd.button
            className: 'btn btn-default btn-sm u-small-spacing-left'
            onClick: null
          , 'More...'
      if @collapsed()
        null
      if @expanded()
        @renderExpanded()
      if @editing() or @saving()
        @renderEditing()

module.exports = ResolutionItem
