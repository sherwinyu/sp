Sysys.DayTransform = DS.Transform.extend
  # expects json to be a "string" of form. This is what active-model-serializers is sending us, at
  # least, when the model is declared with type "Day"
  # YYYY-MM-DD
  #
  # NOTE: we cannot use `new Date(json)` because that will parse the
  # date as UTC timestamp, giving us a different day in the local timestmap
  #   new Date("2013-12-06") => Thu Dec 05 2013 19:00:00 GMT - 0500
  deserialize: (json) ->
    moment(json).toDate()

  serialize: (date) ->
    moment(date).format('YYYY-MM-DD')
