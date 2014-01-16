Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')

  activities: Sysys.attr()

  totalLength: (->
    totalLength = 0
    for name, act of @get('activities')
      totalLength += act.duration
    return totalLength
  ).property('activites.@each')

  productivityIndex: (->
    totalLength = @get('totalLength')
    weightedSum = 0
    for name, act of @get('activities')
      weightedSum += act.productivity * act.duration
    (weightedSum/totalLength).toFixed 3
  ).property('activities')

Sysys.RescueTimeDp.reopenClass
  totalLength: (rtdps) ->
    totalLength = 0
    for rtdp in rtdps
      totalLength += rtdp.get('totalLength')
    return totalLength

  productivityIndex: (rtdps) ->
    totalLength = 0
    weightedSum = 0
    for rtdp in rtdps
      totalLength += rtdp.get('totalLength')
      weightedSum += rtdp.get('productivityIndex') * rtdp.get('totalLength')
    return (weightedSum/totalLength).toFixed 3
