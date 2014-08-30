Sysys.DashboardController = Ember.ObjectController.extend

  needs: [ 'rescue_time_dps', 'day' ]

  newDayAvailable: false
  newDayId: ''

  # dayStartedBinding: 'controllers.day.startedAt'

  # TODO(syu): make dependent on now
  last3hoursStart: (->
    moment().subtract 3, 'hours'
  ).property().volatile()

  # moment
  dayStart: (->
    moment(@get('controllers.day.startedAt') || moment("9:30", "H:mm"))
  ).property('controllers.day.startedAt')

  productivityPulse: (->
    start = @get('controllers.rescue_time_dps.start')

    # 3 hours
    last3hoursStart = @get('last3hoursStart')
    last3hoursRtdps = @get('controllers.rescue_time_dps').filter( (rtdp) ->
      last3hoursStart.isBefore rtdp.get('time')
    )

    # dayStart
    dayStart = @get('dayStart')
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
  ).property 'controllers.rescue_time_dps.content.@each', 'dayStart'

  # TODO(syu) -- make this a handlebars helper
  s_last3hourTimeRange: (->
    from = @get('last3hoursStart')?.format "HH:mm"
    to = moment().format "HH:mm"
    "#{from} - #{to}"
  ).property('last3hoursStart')

  s_sinceDayStart: (->
    from = @get('dayStart')?.format "HH:mm"
    to = moment().format "HH:mm"
    "#{from} - #{to}"
  ).property('dayStart')


  actions:
    refreshProductivity: ->
      @get('store').filter 'rescue_time_dp', {refresh: true}, (rtdp) ->
        true

    reloadDashboard: ->
      dayPromise = @get('store').find 'day', @get('newDayId')
      dayPromise.then (day) =>
        @controllerFor('day').set('model', day)
