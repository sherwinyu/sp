Store = require 'react/flux/store'
Dispatcher = require 'react/flux/dispatcher'
EventEmitter = require('events').EventEmitter

EventConstants = {
  RESOLUTIONS_LOADED: 'RESOLUTIONS_LOADED'
}

class ResolutionsStore extends Store

  getState: ->
    resolutions: @resolutions

  resetState: ->
    @resolutions = []

  payloadHandler: (action) ->
    switch action.actionType
      when EventConstants.RESOLUTIONS_LOADED
        @resolutions = action.resolutions

module.exports =  new ResolutionsStore(Dispatcher)
