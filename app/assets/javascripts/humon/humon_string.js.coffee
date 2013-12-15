Humon.String = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')
Humon.String.reopenClass
  coerceToDefaultJson: (json) ->
    "#{json}"
