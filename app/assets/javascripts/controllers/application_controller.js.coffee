Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'

  debug : false

  git: null
  lastPing: null

  init: ->
    @_super()
    @set 'git', window?._sp_vars?.git
    pingTimer = new PingTimer
    pingTimer.ping (response) =>
      console.log response
      @set 'lastPing', response

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
  ping: (handler)->
    url = "/ping"
    pingFtn = ->
      console.log 'pinging', new Date()
      $.get(url).then(handler)
    setInterval( pingFtn, 5000)
