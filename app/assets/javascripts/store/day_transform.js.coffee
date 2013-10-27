Sysys.DayTransform = DS.Transform.extend
  deserialize: (json) ->
    Date.parse(json)
  serialize: (date) ->
    mmt(date).format('YYYY-MM-DD')

