Dispatcher = require 'react/flux/dispatcher'
net = require 'utils/net'
EventConstants = require 'react/event_constants'

ResolutionDAO =
  create: (resolution) ->
    net.postJSON
      url: '/resolutions.json'
      data:
        resolution: resolution

ResolutionActions =
  createResolution: (resolution = {}) ->
    defaults =
      text: 'Untitled resolution'
      type: 'goal'
    resolution = $.extend defaults, resolution
    ResolutionDAO.create resolution
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_CREATE_COMPLETED
          resolution: response.resolution

  updateResolution: (resolutionId, resolution) ->

module.exports = ResolutionActions
