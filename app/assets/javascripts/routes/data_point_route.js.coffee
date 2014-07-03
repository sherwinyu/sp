Sysys.DataPointRoute = Ember.Route.extend
  model: (params)->
   dpPromise = @get('store').find 'data_point', params.data_point_id
  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'data_point', data_point: model.get('id')

Sysys.DataPointIndexRoute = Ember.Route.extend()

Sysys.DataPointsRoute = Ember.Route.extend
  model: (params)->
   dpsPromise = @get('store').findAll 'data_point'
  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'data_points'

Sysys.RescueTimeDpsRoute = Ember.Route.extend
  model: (params, transition)->
     rtdpPromise = @get('store').findAll 'rescue_time_dp'

  afterModel: (resolvedModel, transition) ->
    utils.track "visit", route: 'rescue_time_dps'

Sysys.RescueTimeDpsIndexRoute = Ember.Route.extend()
