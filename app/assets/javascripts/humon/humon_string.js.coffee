Humon.String = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')

Humon.String.reopenClass
  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    "#{json}"

Humon.CatchallString = Humon.String.extend()

Humon.CatchallString.reopenClass
  _j2hnv: (json, context) ->
    if context.node.get('initialized')
      value = @valueFromJson(json, context)
    else
      # If the node isn't initialized yet, then pass through the value
      value = json
    context.node.get('nodeMeta').catchAll = true
    Humon.String.create(_value: value, node: context.node)

  valueFromJson: (json)->
    "#{json}"

  matchesJson: (json) ->
    true
