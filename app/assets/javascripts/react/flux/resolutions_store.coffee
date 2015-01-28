Store = require 'react/flux/store'
Dispatcher = require 'react/flux/dispatcher'
EventEmitter = require('events').EventEmitter
EventConstants = require 'react/event_constants'

class ResolutionsStore extends Store

  _group: (resolutions) ->
    _.groupBy resolutions, (resolution) -> resolution.group

  getState: ->
    resolutions: @resolutions
    groupedResolutions: @_group @resolutions

  resetState: ->
    @resolutions = [
      {
        text: 'Commit by Friday 5pm'
        frequency: 'weekly'
        count: 23
        doneInInteval: true
        group: ''
      }
      {
        text: 'Commit by Friday 5pm'
        frequency: 'weekly'
        count: 23
        doneInInteval: true
        group: ''
      }

    ]

  payloadHandler: (action) ->
    switch action.actionType
      when EventConstants.RESOLUTIONS_LOAD_DONE
        @resolutions = action.resolutions
        @emitChange()
      when EventConstants.RESOLUTION_CREATE_DONE
        @resolutions.push action.resolution
        @emitChange()

module.exports =  new ResolutionsStore(Dispatcher)
