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

  getInitialState: ->
    state =
      filter:
        filterOn: false
        daily: true
        weekly: true
    _.extend state, ResolutionsStore.getState()

  _filterLinkState: (key) ->
    return {
      value: @state.filter[key]
      requestChange: (newValue) =>
        filterState = React.addons.update @state.filter, _.object([key], [{$set: newValue}])
        @setState {filter: filterState}
        return
    }

  _resolutionsUpdateHandler: -> @setState ResolutionsStore.getState()

  componentDidMount: ->
    ResolutionActions.loadResolutions()
    ResolutionsStore.addChangeListener @_resolutionsUpdateHandler

  componentWillUnmountMount: -> ResolutionsStore.removeChangeListener @_resolutionsUpdateHandler

  renderResolutionTitle: (title) ->
    rd.h4 null, title

  renderResolutionItem: (resolution) ->
    return

  newResolution: ->
    ResolutionActions.createResolution()

  renderFilterBar: ->
    rd.div null,
      rd.label className: 'checkbox-inline',
        rd.input
          type: 'checkbox'
          checkedLink: @_filterLinkState('filterOn')
        'Filter resolutions?'
      rd.label className: 'checkbox-inline',
        rd.input
          type: 'checkbox'
          disabled: not @_filterLinkState('filterOn').value
          checkedLink: @_filterLinkState('daily')
        'Daily'
      rd.label className: 'checkbox-inline',
        rd.input
          type: 'checkbox'
          disabled: not @_filterLinkState('filterOn').value
          checkedLink: @_filterLinkState('weekly')
        'Weekly'

  filterResolution: (resolution) ->
    if not @state.filter.filterOn
      true
    else if @state.filter[resolution.frequency]
      true
    else
      false

  renderResolutions: ->
    rd.div className: 'resolutions',
      rd.h2 null,
        'Resolutions'
      rd.button {
        className: 'btn btn-default u-spacing-bottom'
        onClick: @newResolution
      },
        'Create resolution'

      @renderFilterBar()

      for group, resolutions of @state.groupedResolutions
        rd.div className: 'panel panel-default', key: group,
          rd.div className: 'panel-heading',
            @renderResolutionTitle group
          rd.ul className: 'list-group',
            for resolution in resolutions
              if @filterResolution resolution
                ResolutionItem
                  key: resolution.id
                  resolution: resolution
                  initialGroups: @state.groups

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


module.exports = ResolutionsIndex
