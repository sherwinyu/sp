Humon.Time = Humon.Date.extend()

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
      ret.value ||= json.constructor == String && @_inferAsTimeStampFormat json
    catch error
      console.error error.toString()
    finally
      if ret.value
        mmt = moment(ret.value)

        # Note: if this is called from Date#matchesJson(json),
        # no context will be avaialable, which is why we need
        # the context?.defaultDate guard.
        #
        # This means we should probably refactor it
        if context?.defaultDate?
          defaultMmt = moment context.defaultDate
          mmt.date(defaultMmt.date())
          mmt.year(defaultMmt.year())
          mmt.month(defaultMmt.month())

          ret.value = mmt.toDate()

        ret.matches = true
      return ret
)
