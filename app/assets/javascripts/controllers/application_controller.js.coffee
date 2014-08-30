Sysys.ApplicationController = Ember.Controller.extend

  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'

  debug : false

  git: null
  heartbeat: null

  init: ->
    @_super()

    @set 'heartbeat', new Ember.RSVP.Promise (resolve) ->
      resolve window._sp_vars.heartbeat

    @set 'git', window?._sp_vars?.git
    pingTimer = new PingTimer @

  actions:
    toggleDbg: ->
      sheet = document.styleSheets[0]
      rules = sheet.cssRules
      @debug ^= true
      if @debug
        sheet.addRule(".node > .debug-auto-hide:not(.node-debug-panel)", "visibility: visible")
      else
        sheet.deleteRule( rules.length - 1 )

class PingTimer

  heartbeatHandler: (heartbeat) ->
    @appCtrl.set('heartbeat', heartbeat)
    console.log heartbeat

  constructor: (@appCtrl) ->
    @ping()

  ping: ->
    url = "/ping"
    pingFtn = =>
      console.log 'pinging', new Date()
      get = $.get(url)
      get.then (heartbeat) => @heartbeatHandler heartbeat
    setInterval(pingFtn, 5000)

# source https://gist.github.com/stefanpenner/587e5f047d2f412fe463
Ember.RSVP.on 'error', (error) ->
  # optionally, only for errors
  # if (error instanceof Error) { console.assert(false, error); }
  console.assert(false, error)

  if error && error.stack
    # console.error provides clickable stack-traces in chrome debugger
    console.error(error.stack)
