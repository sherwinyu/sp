Store = require 'react/flux/store'
Dispatcher = require 'react/flux/dispatcher'

ResolutionsStore = $.extend {}, EventEmitter.prototype,

  getState: ->
    return _resolutions

  payloadHandler: (action) ->
    switch action.actionType
      when EventConstants.

module.exports =  ResolutionsStore Dispatcher
