Humon.Text = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')

Humon.Text.reopenClass
  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    "#{json}"

  _initJsonDefaults: (json) ->
    json || "long-text-here"

  matchesJson: (json) ->
    typeof json == "string"


