Humon.Time = Humon.Date.extend(
  precommitInputCoerce: (input) ->
    {matches, value} = Humon.Time._inferFromJson(input)

    #
    # This means we should probably refactor it
    if (dd = @get('node.nodeMeta')?.defaultDate)?
      mmt = moment value
      defaultMmt = moment dd
      mmt.date(defaultMmt.date())
      mmt.year(defaultMmt.year())
      mmt.month(defaultMmt.month())

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
)
