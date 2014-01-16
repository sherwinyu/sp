Humon.Number = Humon.Primitive.extend()
Humon.Number.reopenClass
  ##
  # @override
  # @return [boolean]
  matchesJson: (json) ->
    matches = false
    matches ||= (json?.constructor == String && json.match /^\d+$/)
    return matches || @_super(json)
