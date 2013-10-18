Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')

  activities: Sysys.attr()

  displayActivities: (->
   ({
    name: k,
    duration: v.duration
    category: v.category}
   ) for k, v of @get('activities')
  ).property 'activities'

  productivityIndex: (->
    totalLength = 0
    weightedSum = 0
    for name, act of @get('activities')
      totalLength += act.duration
      weightedSum += act.productivity * act.duration
    (weightedSum/totalLength).toFixed 3
  ).property('activities')

  totalDurationString: (->
    totalLength = 0
    for name, act of @get('activities')
      totalLength += act.duration
    totalLength
    utils.sToDurationString totalLength
  ).property('activities')

  timeString: (->
    mmt = moment(@get('time'))
    mmt.format('dddd, MMM D @ ha')
  ).property 'time'

  timeRangeString: (->
    mmt = moment(@get('time'))
    mmt2 = mmt.add('hours', 1)
    mmt2.format('ha')
  ).property 'time'

  relativeTimeString: (->
    mmt = moment(@get('time'))
    if Math.abs(mmt.diff(moment(), 'hours')) > 22
      mmt.calendar()
    else
      mmt.fromNow()
  ).property 'time'
