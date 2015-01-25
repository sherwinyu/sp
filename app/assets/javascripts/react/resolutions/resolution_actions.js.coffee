net = require 'utils/net'

ResolutionDAO =

ResolutionActions =
  createResolution: (resolution) ->
    net.postJSON
      url: '/resolutions/'
      data: {name: name, sharing: 'public', folder: folder}


  updateResolution: (resolutionId, resolution) ->



