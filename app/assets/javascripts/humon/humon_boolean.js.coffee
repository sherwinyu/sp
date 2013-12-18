Humon.Boolean = Humon.Primitive.extend
  toggle: ->
    @toggleProperty '@_value'

Humon.Boolean.reopenClass
  _initJsonDefaults: (json) ->
    json || false
