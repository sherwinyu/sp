Sysys.RescueTimeDpController = Ember.ObjectController.extend
  init: ->
    @get('content')
    @_super()

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

  totalDurationString: (->
    totalLength = 0
    for name, act of @get('activities')
      totalLength += act.duration
    totalLength
    utils.sToDurationString totalLength
  ).property('activities')

  displayActivities: (->
   ({
    name: k,
    duration: v.duration
    category: v.category
    productivity: v.productivity
   }
   ) for k, v of @get('activities')
  ).property 'activities'
