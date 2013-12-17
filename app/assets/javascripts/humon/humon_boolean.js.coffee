Humon.Boolean = Humon.Primitive.extend()
Humon.Boolean.reopenClass
  _initJsonDefaults: (json) ->
    json || false
