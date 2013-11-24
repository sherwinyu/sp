Humon.Date = Humon.Primitive.extend()
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
  #   param json json: the candidate json object
  #   return: if successful, a value of this type
  #           if unsuccessful, a falsy value
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # type registration order (calls to HumonType.register)
  #
  # TODO(syu): update and generalize to work for all humon types and include it in
  # the standard suite. AKA make it work for booleans: return a hash {matchesType, value}
  # problem is that right now yu can't distinguish between a literal false and a false as in failure
  _inferFromJson: (json) ->
    ret = false
    try
      ret ||= (typeof json is "object" && json.constructor == Date && json)
      # ret ||= @_inferViaDateParse(json)
      ret ||= json.constructor == String && @_inferAsMomentFormat(json)
      ret ||= json.constructor == String && @_inferAsMomentValidDate(json)
    catch error
      console.error error.toString()
      ret = false
    finally
      ret

  j2hnv: (json, context) ->
    value = @_inferFromJson(json)
    @_klass().create(_value: value, node: context.node)
  matchesJson: (json) ->
    !!@_inferFromJson(json)
