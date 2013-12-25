Humon.Date = Humon.Primitive.extend(
  mmt: ->
    # Should we clone this?
    moment(@_value)
)
Humon.Date.reopenClass
  _momentFormatTransforms:
    'ddd MMM D': (string, format) ->
      @_momentFormatAndValidate string, format
    'ddd MMM D YYYY': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY MM DD': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY M D': (string, format)->
      @_momentFormatAndValidate string, format
    _momentFormatAndValidate: (string, format) ->
      date = @_momentFormat(string, format).toDate()
      valid = !isNaN(date.getTime()) && moment(date).format(format) == string
      {valid: valid, date: date}
    _momentFormat: (string, format) ->
      mmt = moment(string, format)

  _inferAsMomentFormat: (string) ->
    return false if string.constructor != String
    for format, transform of @_momentFormatTransforms
      {valid, date} = @_momentFormatTransforms[format](string, format)
      if valid
        return date
    false

  _inferAsMomentValidDate: (string) ->
    moment(string).isValid() && moment(string).toDate()

  # _inferFromJson -- attempts to convert a json value to this type
  # @param json json: the candidate json object
  # @return [object]   return: if successful, a value of this type
  #   - matches [boolean]: whether the match was a success
  #   - value [underlying value]:
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # type registration order (calls to HumonType.register)
  _inferFromJson: (json, context) ->
    ret =
      matches: false
    try
      return {matches: false} unless json?
      ret.value ||= (typeof json is "object" && json.constructor == Date && json)
      ret.value ||= json.constructor == String && @_inferAsMomentFormat(json)
      ret.value ||= json.constructor == String && @_inferAsMomentValidDate(json)
    catch error
      console.error error.toString()
    finally
      if ret.value
        ret.matches = true
      return ret

  ##
  # @override
  # context
  #   - dateTimeContext
  valueFromJson: (json, context) ->
    @_inferFromJson(json, context).value

  matchesJson: (json) ->
    @_inferFromJson(json).matches
