Humon.Time = Humon.Date.extend()

Humon.Time.reopenClass(
  # TODO(syu): handle case when we can pass it a DATE object, and it'll get
  # recognized as a time beause of the metatemplate

  # @override
  _momentFormatTransforms:
    'HH:mm': (string, format) ->
      @_momentFormatAndValidate string, format
    'H:mm:ss': (string, format)->
      @_momentFormatAndValidate string, format
    'hh:mma': (string, format)->
      @_momentFormatAndValidate string, format
    _momentFormatAndValidate: (string, format) ->
      date = @_momentFormat(string, format).toDate()
      valid = !isNaN(date.getTime()) # && moment(date).format(format) == string
      {valid: valid, date: date}
    _momentFormat: (string, format) ->
      mmt = moment(string, format)

  _inferFromJson: (json) ->
    ret =
      matches: false
    try
      ret.value ||= json.constructor == String && @_inferAsMomentFormat(json)
    catch error
      console.error error.toString()
    finally
      if ret.value
        ret.matches = true
      return ret
)
