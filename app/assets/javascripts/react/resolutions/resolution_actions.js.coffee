Dispatcher = require 'react/flux/dispatcher'
net = require 'utils/net'
EventConstants = require 'react/event_constants'

ResolutionDAO =
  all: ->
    net.getJSON '/resolutions.json'

  create: (resolution) ->
    net.postJSON
      url: '/resolutions.json'
      data:
        resolution: resolution

  update: (id, resolution) ->
    net.patchJSON
      url: "/resolutions/#{id}.json"
      data:
        resolution: resolution


ResolutionActions =
  loadResolutions: ->
    ResolutionDAO.all()
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTIONS_LOAD_DONE
          resolutions: response.resolutions

  createResolution: (resolution = {}) ->
    defaults =
      text: 'Untitled resolution'
      type: 'goal'
    resolution = $.extend defaults, resolution
    ResolutionDAO.create resolution
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_CREATE_DONE
          resolution: response.resolution

  updateResolution: (id, resolution) ->
    ResolutionDAO.update id, resolution
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_UPDATE_DONE
          resolutionId: response.resolution.id
          resolution: response.resolution

module.exports = ResolutionActions
