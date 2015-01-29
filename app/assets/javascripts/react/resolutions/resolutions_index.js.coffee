React = require 'react'

ResolutionActions = require 'react/resolutions/resolution_actions'
ResolutionsStore = require 'react/flux/resolutions_store'

bs = require 'utils/bs'
rd = React.DOM

ResolutionsIndex = React.createClass

  propTypes:
    # Resolution refers to a single trackable item, and they are grouped together
    # ResolutionCompletion
    #
    # resolution: React.PropType.shape(
    #   groupName: 'Utilize Sherwin Points'
    #   name: React.PropTypes.string
    #   frequency: React.PropTypes.string
    #   recentCompletions: array
    #   isHeader
    #   information
    #   type: {info, header, goal}
    # ).isRequired
    resolutions: React.PropTypes.array

  getInitialState: -> ResolutionsStore.getState()

  _resolutionsUpdateHandler: -> @setState ResolutionsStore.getState()

  componentDidMount: ->
    ResolutionActions.loadResolutions()
    ResolutionsStore.addChangeListener @_resolutionsUpdateHandler

  componentWillUnmountMount: -> ResolutionsStore.removeChangeListener @_resolutionsUpdateHandler

  render: ->
    rd.div className: 'container',
      rd.h1 null, 'Goal management'
      bs.Row null,
        rd.nav className: 'navbar navbar-default', role: 'navigation',
          rd.div className: 'collapse navbar-collapse',
            rd.form className: 'navbar-form navbar-left', role: 'search',
              bs.FormGroup null,
                bs.FormInput
                  placeholder: 'Search Activities'
                  type: 'text'
              rd.button type: 'submit', className: 'btn btn-default',
                'Go'


      bs.Row null,
        bs.Col sm: 8,
          @renderResolutions()

  renderResolutionTitle: (title) ->
    rd.h4 null, title

  renderResolutionItem: (resolution) ->
    return

  newResolution: ->
    ResolutionActions.createResolution()

  renderResolutions: ->
    rd.div className: 'resolutions',
      rd.h3 null,
        'Resolutions'
      rd.button {
        onClick: @newResolution
      },
        'Create resolution'

      rd.div className: 'panel panel-default resolution-theme',
        rd.div className: 'panel-heading',
          @renderResolutionTitle 'I. Be more appreciative'
        rd.ul className: 'list-group',
          for resolution in @state.resolutions
            console.log resolution
            ResolutionItem resolution: resolution
          ResolutionItem
            resolution:
              text: 'Commit by Friday 5pm',
              trackFrequency: 'weekly'
              count: 23
              goal: 150
              doneInInterval: true
          ResolutionItem
            resolution:
              text: 'Once either sunday or saturday',
              trackFrequency: 'weekly'
              count: 23
              goal: 150
              doneInInterval: true
          ResolutionItem
            resolution:
              text: 'Schedule'
              routine: ['30m mindfulness meditation', '30m express appreciation', '120m play/work session']
          ResolutionItem
            resolution:
              text: 'Treat this as a higher priority over other things'
              type: 'help'


      rd.div null,
        @renderResolutionTitle 'II. Utilize Sherwin Points'

      rd.div null,
        @renderResolutionTitle 'III. Utilize Sherwin Points'

      rd.div null,
        @renderResolutionTitle 'IV. Personal projects'

      rd.div null,
        @renderResolutionTitle 'IV. Persoal projects'

ResolutionItem = React.createClass

  propTypes:
    resolution: React.PropTypes.shape(
      text: React.PropTypes.string.isRequired
      trackFrequency: React.PropTypes.string
      routine: React.PropTypes.object
      type: React.PropTypes.string
      currentCount: React.PropTypes.number
      targetCount: React.PropTypes.number
      doneInInterval: React.PropTypes.boolean
    )

  getInitialState: ->
    expanded: false
    editing: false
    resolution: @props.resolution

  toggleExpanded: ->
    if not @state.editing
      @setState expanded: not @state.expanded

  saveResolution: ->
    console.assert @props.resolution.id?
    ResolutionActions.updateResolution @props.resolution.id, @state.resolution

  _resolutionLinkState: (key) ->
    return {
      value: @state.resolution[key]
      requestChange: (newValue) =>
        newResolution = React.addons.update @state.resolution, _.object([key], [{$set: newValue}])
        @setState {resolution: newResolution}
        return
    }

  render: ->
    resolution = @props.resolution
    {currentCount, targetCount} = resolution

    rd.li
      className: 'list-group-item',
      onClick: @toggleExpanded
    ,
      if not @state.expanded
        rd.p null,
          resolution.text

      if @state.editing
        bs.FormGroup null,
          bs.Label null,
            'Text'
          bs.FormInput
            valueLink: @_resolutionLinkState 'text'

          bs.Label null,
            'Group'
          bs.FormInput
            valueLink: @_resolutionLinkState 'group'

          rd.button
            className: 'btn btn-success u-spacing-top',
            onClick: @saveResolution
          ,
            'Save'


      if @state.expanded and not @state.editing
        bs.Row null,
          bs.Col sm: 7,
            rd.p null,
              resolution.text

              rd.button
                className: 'btn btn-default btn-sm'
                onClick: => @setState editing: true
              ,
                'Edit'

              if resolution.trackFrequency
                rd.span className: 'label label-info u-tiny-spacing-left', trackFrequency

          bs.Col sm: 5,
            if currentCount? and targetCount?
              rd.div className: 'progress',
                rd.div
                  className: 'progress-bar'
                  'aria-valuemin': 0
                  'aria-valuenow': currentCount
                  'aria-valuemax': targetCount
                  style:
                    width: "#{currentCount/ targetCount * 100}%"
                ,
                  "#{currentCount}/#{targetCount}"

            if not resolution.type == 'help'
              rd.button
                className: 'btn btn-primary btn-sm'
                type: 'button'
              ,
                'Track now '
              if not resolution.doneInInterval
                rd.span
                  className: 'badge u-tiny-spacing-left'
                ,
                  '!'

module.exports = ResolutionsIndex
