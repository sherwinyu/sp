Sysys.RescueTimeDpsController = Ember.ArrayController.extend
  # start and end are moment objects
  start: false
  end: false

  queryParams: ['start', 'end']
  rtdpWithinTimeRange: (rtdp) ->
    ts = rtdp.get('time')
    if @start
      return false unless @start.isBefore  ts
    if @end
      return false unless @end.isAfter  ts
    return true
