Sysys.Day = DS.Model.extend
  date: Sysys.attr('day')
  note: Sysys.attr('string', defaultValue: -> "warg")
  sleep: Sysys.attr('complex')
  summary: Sysys.attr('complex')
  goals: Sysys.attr()

  typeMap:
    sleep:
      name: "sleep"
    note:
      name: "string"
    summary:
      name: "summary"
    goals:
      name: "goals"

  yesterday: DS.belongsTo('day')
  tomorrow: DS.belongsTo('day')

  startedAt: (->
    @get('sleep.awake_at')
  ).property('sleep')

