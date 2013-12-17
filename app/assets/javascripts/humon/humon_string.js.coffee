Humon.String = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')

Humon.String.reopenClass
  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    "#{json}"
  _initJsonDefaults: (json) ->
    json || ""
