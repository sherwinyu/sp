Humon.Time = Humon.Date.extend(
  # Currently does not support modifying the date via
  # the precommitInputCoerce by passing a dated- timestring.
  # TODO(syu): support dated-timestrings.
  #
  # Defaults to using dayStartsAt as 4am
  precommitInputCoerce: (input) ->

    {matches, value: time} = Humon.Time._inferFromJson(input)

    # FOR NOW, treat "value" as a TIME (not a datetime)
    meta = @get('node.nodeMeta')

    # If this node already has a value, then use that
    # Otherwise, use the default date
    if @get('node.initialized')
      experiencedDate = utils.date.dateTimeToExperiencedDate @_value
    else
      experiencedDate = meta?.defaultDate || utils.date.todayAsExperiencedDate()

    dtMmt =  utils.date.experiencedDateAndTimeToDateTime(experiencedDate, time)

    value = dtMmt.toDate()

    return ret =
      coerceSuccessful: matches
      coercedInput: value
)


Humon.Time.reopenClass(
  _inferAsTimeStampFormat: (string)->
    #        1       2     3 4
    #        hour    min     sec
    regex = /((\d\d?):(\d\d)(:(\d\d))?)/
    if m = string.match regex
      return moment(m[0], "HH:mm:ss").toDate()

    # return moment(hour: parseInt(m[1]), minute: parseInt(m[2]), seconds: parseInt(m[4])).toDate()
    false

  _inferFromJson: (json, context) ->
    ret =
      matches: false
    try
      return {matches: false} unless json?
      ret.value ||= (typeof json is "object" && json.constructor == Date && json)
      ret.value ||= json.constructor == String && @_inferAsISODateString json
      ret.value ||= json.constructor == String && @_inferAsTimeStampFormat json
    catch error
      console.error error.toString()
    finally
      if ret.value
        mmt = moment(ret.value)
        ret.matches = true
      return ret
)
