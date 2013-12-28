Sysys.Day = DS.Model.extend
  date: Sysys.attr('day')
  note: Sysys.attr('string', defaultValue: -> "warg")
  sleep: Sysys.attr('complex')
  summary: Sysys.attr('complex')
  goals: Sysys.attr()

  typeMap: (->
    sleep:
      name: "sleep"
      defaultDate: @get('date')
    note:
      name: "string"
      defaultDate: @get('date')
    summary:
      name: "summary"
      defaultDate: @get('date')
    goals:
      name: "goals"
      defaultDate: @get('date')
  ).property().volatile()

  yesterday: DS.belongsTo('day')
  tomorrow: DS.belongsTo('day')

  startedAt: (->
    @get('sleep.awake_at')
  ).property('sleep')

  endedAt: (->
    @get('sleep.lights_out_at')
  ).property('sleep')
