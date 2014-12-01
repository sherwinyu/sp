window.ts = -> utils.ts()

window.getCursor = (node) ->
  # first convert node to a HTMLElement, always
  if node instanceof jQuery
    node = node[0]

  # if it's a div or a span or a node-field
  # then use the divGetCursor routine
  # WARNING this is not robust
  if node.tagName is "DIV" || node.tagName is "SPAN" || node.tagName is "NODE-FIELD"
    return divGetCursor(node)
  $(node).prop('selectionStart')

window.setCursor = (node, pos) ->
  node = if typeof node == "string" || node instanceof String
           document.getElementById node
         else
           node
  unless node
    return false
  if node.tagName is "DIV" || node.tagName is "SPAN" || node.tagName is "NODE-FIELD"
    return divSetCursor(node, pos, pos)
  if node.createTextRange
    textRange = node.createTextRange()
    textRange.collapse true
    textRange.moveEnd pos
    textRange.select()
    true
  else if node.setSelectionRange
    node.setSelectionRange pos, pos
    true
  false

window.utils =

  ##
  # @param obj The object to be cloned
  # @param opts
  #   - deep [boolean] whether to deep clone
  clone: (obj, opts={}) ->
    if opts.deep
      jQuery.extend(true, {}, obj)
    else
      jQuery.extend({}, obj)

  ts: ->
    moment().format("HH:mm:ss")
  # expects: URL, data
  ajax: (opts) ->
    opts.data = JSON.stringify opts.data
    defaults =
      contentType: "application/json"
      dataType: "json"
      type: 'GET'
    $.extend defaults, opts
    $.ajax defaults

  put: (opts) ->
    $.extend true, opts, data: {"_method": 'put'}
    # opts.data = JSON.stringify opts.data
    defaults =
      headers:
        "X-Http-Method-Override": "put"
      type: 'post'
    $.extend defaults, opts
    @ajax defaults

  post: (opts) ->
    # opts.data = JSON.stringify opts.data
    defaults =
      type: 'POST'
    $.extend defaults, opts
    @ajax defaults

  delete: (opts) ->
    $.extend true, opts, data: {"_method": 'delete'}
    defaults =
      headers:
        "X-Http-Method-Override": "delete"
      type: 'post'
    $.extend defaults, opts
    @ajax defaults

  delayed: (ms, callback) ->
    setTimeout(callback, ms)

  peek: (dfd) ->
    x = null
    dfd.then( (result) -> x = result)
    x

  track: (eventName, eventOptions) ->
    $.extend(eventOptions, @_trackProperties)
    mixpanel?.track eventName, eventOptions

  _trackProperties: {}

  registerTrackingProperty: (key, val) ->
    @_trackProperties[key] = val

  sToDurationString: (seconds) ->
    fmtStr = "m[m] s[s]"
    if seconds >= 60 * 60
      fmtStr = "h[h] m[m] s[s]"
    ret = moment(1000 * seconds).utc().format(fmtStr)
    ret

  tick: (milliseconds=1000)->
    if @ticking
      clearInterval @tickIntervalId
      @ticking = false
    else
      @tickIntervalId = setInterval((-> console.log utils.ts() ), milliseconds)
      @ticking = true

window.utils.date =
  mmt: (arg) ->
    console.warn "Expected moment or date" if arg.constructor != Date
    moment(arg)

  verbose: (date) ->
    mmt = @mmt(date)
    mmt.format('LLLL')

  asString: (date) ->
    "#{@humanized(date)} (#{@relative(date)})"
    @humanized(date)

  humanized: (date) ->
    mmt = @mmt(date)
    if mmt.isSame(new Date(), 'year')
      mmt.format("ddd, MMM D")
    else
      mmt.format("ddd, MMM D, YYYY")

  relative: (date) ->
    mmt = @mmt(date)
    mmt.fromNow()

  # param date Date
  # returns: a Date
  tomorrow: (date) ->
    mmt = @mmmt(date)
    if mmt.hour() > 3
      mmt.add days: 1
    mmt.startOf('day')
    mmt.toDate()

  ##
  # @param experiencedDate [moment|date] - used as a date
  # @param time [moment|date] - used as a time
  # @return [moment] representing a DateTime that fits the
  #
  # experiencedDate and time
  experiencedDateAndTimeToDateTime: (experiencedDate, time) ->
    dateTimeMmt = moment experiencedDate
    time = moment time

    dateTimeMmt.hour time.hour()
    dateTimeMmt.minute time.minute()
    dateTimeMmt.second time.second()

    if dateTimeMmt.hour() < 4
      dateTimeMmt.add 1, 'days'
    return dateTimeMmt

  ##
  # Returns the experienced date at the current time.
  # @return [moment] as date, with HMS wiped
  todayAsExperiencedDate: ->
    mmt = moment()
    return utils.date.dateTimeToExperiencedDate( moment() )

  ##
  # @param dateTime A moment or date representing a dateTime (timezoned)
  # @param dayStartsAt optional integer hour
  # @return [moment] with HMS zero'd
  #
  # Raises an error if dateTime is not a valid date or moment
  dateTimeToExperiencedDate: (dateTime, dayStartsAt=4) ->
    Ember.assert "dateTime must be specified", dateTime
    mmt = moment dateTime
    Ember.assert "dateTime is valid", mmt.isValid()

    if (mmt.hour() < dayStartsAt)
      mmt.subtract 1, 'days'

    # Zero HMS; this is in-place
    mmt.startOf('day')

    return mmt


utils.time =
  mmt: (arg) ->
    console.warn "Expected moment or date" if arg.constructor != Date
    moment(arg)

  verbose: (time) ->
    mmt = @mmt(time)
    mmt.format('HH:mm:ss')

  humanized: (time) ->
    mmt = @mmt(time)
    mmt.format("HH:mm") + " (#{mmt.format("ddd, MMM D")})"

  asString: (time) ->
    mmt = @mmt(time)
    mmt.format("HH:mm")

  relative: (time) ->
    mmt = @mmt(time)
    mmt.fromNow()

utils.datetime =
  isIsoDateString: (string) ->
    return moment(string, "YYYY-MM-DDTHH:mm:ssZ", true).isValid()

  isRailsDateString: (string) ->
    return moment(string, "YYYY-MM-DDTHH:mm:ss.SSSZ", true).isValid()

