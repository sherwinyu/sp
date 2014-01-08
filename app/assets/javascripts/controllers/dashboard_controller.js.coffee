Sysys.DashboardController = Ember.ObjectController.extend
  needs: [ 'rescue_time_dps', 'day' ]
  # dayStartedBinding: 'controllers.day.startedAt'
  productivityPulse: (->
    start = @get('controllers.rescue_time_dps.start')

    # 3 hours
    # last hour
    # dayStart
    dayStart = moment @get('controllers.day.startedAt')
    dayRtdps = @get('controllers.rescue_time_dps').filter( (rtdp) ->
      dayStart.isBefore rtdp.get('time')
    )
    return ret =
      length: Sysys.RescueTimeDp.totalLength dayRtdps
      score: Sysys.RescueTimeDp.productivityIndex(dayRtdps)
  ).property 'controllers.rescue_time_dps.content.@each', 'controllers.day.startedAt'
