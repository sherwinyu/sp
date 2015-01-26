net = require 'utils/net'

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
          actionType: RESOLUTION_CREATE_COMPLETED
          resolution: resolution

  updateResolution: (resolutionId, resolution) ->
