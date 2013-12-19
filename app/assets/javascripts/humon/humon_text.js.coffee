Humon.Text = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')
  precommitInputCoerce: (json) ->
    if typeof json == "string"
      @set '_value', json


Humon.Text.reopenClass
  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    "#{json}"

  _initJsonDefaults: (json) ->
    json || ""

  matchesJson: (json) ->
    typeof json == "string" # && json.length > 255
