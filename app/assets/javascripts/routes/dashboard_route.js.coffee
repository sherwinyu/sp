Sysys.DashboardRoute = Ember.Route.extend
  model: ->
    dayPromise = @get('store').find 'day', 'latest'

  setupController: (controller, model) ->
    @controllerFor('day').set('model', model)

    rtdpsController = @controllerFor('rescue_time_dps')
    rtdpsController.set 'start', moment().subtract(24, 'hours')
    rtdps = @store.filter 'rescue_time_dp', {nargle: true}, (rtdp) ->
      rtdpsController.rtdpWithinTimeRange(rtdp)
    rtdpsController.set('model', rtdps)

    acts = @store.findAll 'act'
    actsController = @controllerFor 'acts'
    actsController.set 'model', acts

  renderTemplate: ->
    @_super()
    @render 'day',
      into: 'dashboard'
      outlet: 'day'
      controller: @controllerFor('day')
    @render 'rescue_time_dps',
      into: 'dashboard'
      outlet: 'rescue_time_dps'
      controller: @controllerFor('rescue_time_dps')
    @render 'acts',
      into: 'dashboard'
      outlet: 'acts'
      controller: @controllerFor('acts')

