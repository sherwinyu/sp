Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')

  activities: Sysys.attr()

  productivityIndex: (->
    totalLength = 0
    weightedSum = 0
    for name, act of @get('activities')
      totalLength += act.duration
      weightedSum += act.productivity * act.duration
    (weightedSum/totalLength).toFixed 3
  ).property('activities')

