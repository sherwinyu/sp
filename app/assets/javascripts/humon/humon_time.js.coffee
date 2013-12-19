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

  _inferAsTimeStampFormat: (string)->
    #        1       2     3 4
    #        hour    min     sec
    regex = /((\d\d?):(\d\d)(:(\d\d))?)/
    if m = string.match regex
      return moment(m[0], "HH:mm:ss").toDate()

    # return moment(hour: parseInt(m[1]), minute: parseInt(m[2]), seconds: parseInt(m[4])).toDate()
    false

  _inferFromJson: (json) ->
    ret =
      matches: false
    try
      return {matches: false} unless json?
      ret.value ||= (typeof json is "object" && json.constructor == Date && json)
      ret.value ||= json.constructor == String && @_inferAsTimeStampFormat json
    catch error
      console.error error.toString()
    finally
      if ret.value
        ret.matches = true
      return ret

  valueFromJson: (json) ->
    if json.constructor == String
      @_inferAsTimeStampFormat(json)
    else if json.constructor == Date
      json
    else
      Em.assert "shouldn't ever happen"
)
