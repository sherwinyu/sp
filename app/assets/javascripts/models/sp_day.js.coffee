Sysys.SpDay = DS.Model.extend
  date: Sysys.attr('day')
  note: Sysys.attr('string')
  sleep: Sysys.attr()
  summary: Sysys.attr()

  typeMap:
    sleep: Humon.Sleep
    note: Humon.String
    summary: Humon.DaySummary

  yesterday: DS.belongsTo('sp_day')
  tomorrow: DS.belongsTo('sp_day')

  startedAt: (->
    @get('sleep.awake_at')
  ).property('sleep')