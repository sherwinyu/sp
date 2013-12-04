_app_ = Sysys
_app_.u =
  viewFromId: (id) -> Ember.get("Ember.View.views.#{id}")
  viewFromElement: (ele) -> _app_.u.viewFromId($(ele).first().attr('id'))
  viewFromNumber: (num) -> _app_.u.viewFromId("ember#{num}")
  currentPath: -> _app_.__container__.lookup('controller:application').currentPath
_app_.vfi = _app_.u.viewFromId
_app_.vfe = _app_.u.viewFromElement
_app_.vf = _app_.u.viewFromNumber
_app_.lu = (str) ->
  _app_.__container__.lookup str

window.lu = _app_.lu
window.vf = _app_.vf
window.cp = _app_.u.currentPath
window.rt = -> _app_.lu "router:main"
window.ctrl = (name) -> _app_.lu "controller:#{name}"
window.routes = -> _app_.Router.router.recognizer.names
window.msm = (model)-> model.get('stateManager')
window.mcp = (model)-> msm(model).get('currentPath')
window.mcs = (model)-> msm(model).get('currentState')
window.ts = -> moment().format("HH:mm:ss")

window.getCursor = (node) ->
  # first convert node to a HTMLElement, always
  if node instanceof jQuery
    node = node[0]

  # if it's a div .. or a SPAN TODO
  # then use the divGetCursor routine
  if node.tagName is "DIV" || node.tagName is "SPAN"
    return divGetCursor(node)
  $(node).prop('selectionStart')

window.setCursor = (node, pos) ->
  node = if typeof node == "string" || node instanceof String
           document.getElementById node
         else
           node
  unless node
    return false
  if node.tagName is "DIV" || node.tagName is "SPAN"
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
    mixpanel.track eventName, eventOptions

  _trackProperties: {}

  registerTrackingProperty: (key, val) ->
    @_trackProperties[key] = val

  sToDurationString: (seconds) ->
    fmtStr = "m[m] s[s]"
    if seconds >= 1000 * 60 * 60
      fmtStr = "h[h] m[m] s[s]"
    ret = moment(1000 * seconds).utc().format(fmtStr)
    ret

  tick: (milliseconds=1000)->
    if @ticking
      clearInterval @tickIntervalId
      @ticking = false
    else
      @tickIntervalId = setInterval((-> console.log(moment().format "HH:mm:s.SS")), milliseconds)
      @ticking = true

window.utils.date =
  verbose: (date) ->
    mmt = moment(date)
    mmt.format('LLLL')

  asString: (date) ->
    "#{@humanized(date)} (#{@relative(date)})"
    @humanized(date)

  humanized: (date) ->
    mmt = moment(date)
    if mmt.isSame(new Date(), 'year')
      mmt.format("ddd, MMM D")
    else
      mmt.format("ddd, MMM D, YYYY")

  relative: (date) ->
    mmt = moment(date)
    mmt.fromNow()

  # param date Date
  # returns: a Date
  tomorrow: (date) ->
    mmt = moment(date)
    if mmt.hour() > 3
      mmt.add days: 1
    mmt.startOf('day')
    mmt.toDate()

utils.time =
  verbose: (time) ->
    mmt = moment(time)
    mmt.format('HH:mm:ss')

  humanized: (time) ->
    @asString(time)

  asString: (time) ->
    moment(time).format("HH:mm") + " (#{moment(time).format("ddd, MMM D")})"

  relative: (time) ->
    mmt = moment(time)
    mmt.fromNow()
