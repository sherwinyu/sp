Humon.Time = Humon.Date.extend(
  # Defaults to using dayStartsAt as 4am
  precommitInputCoerce: (input) ->
    {matches, value} = Humon.Time._inferFromJson(input)

    meta = @get('node.nodeMeta')

    # The moment to return
    mmt = moment value

    defaultDate = meta?.defaultDate || new Date()
    dayStartsAt = meta?.dayStartsAt || 4

    Humon.Time.setBiasedDateOnTime(mmt, defaultDate, dayStartsAt)
    value = mmt.toDate()

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

  setBiasedDateOnTime: (mmt, defaultDate, dayStartsAt) ->
    defaultMmt = moment defaultDate

    mmt.year(defaultMmt.year())
    mmt.month(defaultMmt.month())
    mmt.date(defaultMmt.date())

    if (mmt.hour() < dayStartsAt)
      mmt.add 1, 'days'

    return mmt
)
