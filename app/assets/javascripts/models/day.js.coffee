Sysys.Day = DS.Model.extend
  date: Sysys.attr('day')
  note: Sysys.attr('string')
  sleep: Sysys.attr()
  summary: Sysys.attr()
  goals: Sysys.attr()

  typeMap:
    sleep: Humon.Sleep
    note: Humon.String
    summary: Humon.Summary
    goals: Humon.Goals

  yesterday: DS.belongsTo('day')
  tomorrow: DS.belongsTo('day')

  startedAt: (->
    @get('sleep.awake_at')
  ).property('sleep')

