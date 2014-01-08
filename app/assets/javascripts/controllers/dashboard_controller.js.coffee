Sysys.DashboardController = Ember.ObjectController.extend
  needs: [ 'rescue_time_dps', 'day' ]
  # dayStartedBinding: 'controllers.day.startedAt'
  productivityPulse: (->
    start = @get('controllers.rescue_time_dps.start')

    # 3 hours
    last3hoursStart = moment().subtract 3, 'hours'
    last3hoursRtdps = @get('controllers.rescue_time_dps').filter( (rtdp) ->
      last3hoursStart.isBefore rtdp.get('time')
    )

    # dayStart
    dayStart = moment @get('controllers.day.startedAt')
    dayRtdps = @get('controllers.rescue_time_dps').filter( (rtdp) ->
      dayStart.isBefore rtdp.get('time')
    )
    return ret =
      last3hours:
        length: utils.sToDurationString Sysys.RescueTimeDp.totalLength last3hoursRtdps
        score: Sysys.RescueTimeDp.productivityIndex last3hoursRtdps
      daily:
        length: utils.sToDurationString Sysys.RescueTimeDp.totalLength dayRtdps
        score: Sysys.RescueTimeDp.productivityIndex dayRtdps
  ).property 'controllers.rescue_time_dps.content.@each', 'controllers.day.startedAt'

  actions:
    refreshProductivity: ->
      @get('store').filter 'rescue_time_dp', {refresh: true}, (rtdp) ->
        true
