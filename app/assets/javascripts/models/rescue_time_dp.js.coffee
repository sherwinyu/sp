Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')
  activities: Sysys.attr()
  displayActivities: (->
    ( ({name: k, duration: v.duration, category: v.category} )for k, v of @get('activities'))
  ).property 'activities'
