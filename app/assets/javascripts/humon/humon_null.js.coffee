Humon.Null = Humon.Primitive.extend()
Humon.Null.reopenClass
  matchesJson: (json) ->
    json == null
