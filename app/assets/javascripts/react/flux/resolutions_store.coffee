Store = require 'react/flux/store'
Dispatcher = require 'react/flux/dispatcher'

EventConstants = {
  RESOLUTIONS_LOADED
}

ResolutionsStore = $.extend {}, EventEmitter.prototype,

  getState: ->
    return @resolutions

  payloadHandler: (action) ->
    switch action.actionType
      when EventConstants.RESOLUTIONS_LOADED
        @resolutions = action.resolutions

module.exports =  ResolutionsStore Dispatcher
