React = require 'react'

ResolutionsStore = require 'react/flux/resolutions_store'

ResolutionActions = require 'react/resolutions/resolution_actions'
ResolutionItem = require 'react/resolutions/resolution_item'


bs = require 'utils/bs'
rd = React.DOM

ResolutionsIndex = React.createClass
  displayName: 'ResolutionsIndex'

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
    #   type: {info, <>header, goal}
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
      rd.h2 null,
        'Resolutions'
      rd.button {
        className: 'btn btn-default u-spacing-bottom'
        onClick: @newResolution
      },
        'Create resolution'

      for group, resolutions of @state.groupedResolutions
        rd.div className: 'panel panel-default',
          rd.div className: 'panel-heading',
            @renderResolutionTitle group
          rd.ul className: 'list-group',
            for resolution in resolutions
              ResolutionItem
                key: resolution.id
                resolution: resolution
                initialGroups: @state.groups

        # rd.div className: 'panel-heading',
        #   @renderResolutionTitle 'I. Be more appreciative'
        # rd.ul className: 'list-group',
        #   for resolution in @state.resolutions
        #     ResolutionItem key: resolution.id, resolution: resolution

module.exports = ResolutionsIndex
