Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')

  activities: Sysys.attr()

  displayActivities: (->
    ( ({name: k, duration: @displayDuration(v.duration * 1000), category: v.category} )for k, v of @get('activities'))
  ).property 'activities'

  weightedProductivity: (->
    totalLength = 0
    weightedSum = 0
    for name, act of @get('activities')
      totalLength += act.duration
      weightedSum += act.productivity * act.duration
    (weightedSum/totalLength).toFixed 3
  ).property('activities')
  totalDuration: (->
    totalLength = 0
    for name, act of @get('activities')
      totalLength += act.duration
    totalLength
    @displayDuration totalLength
  ).property('activities')

  displayDuration: (duration) ->
    moment(duration).utc().format("h[m] mm[s]")
