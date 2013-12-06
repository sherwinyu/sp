Sysys.DayTransform = DS.Transform.extend
  # expects json to be a "string" of form. This is what active-model-serializers is sending us, at
  # least, when the model is declared with type "Day"
  # YYYY-MM-DD
  # e.g.,
  deserialize: (json) ->
    new Date(json)

  serialize: (date) ->
    mmt(date).format('YYYY-MM-DD')

