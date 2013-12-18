Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  debug : false
  actions:
    toggleDbg: ->
      sheet = document.styleSheets[0]
      rules = sheet.cssRules
      @debug ^= true
      if @debug
        sheet.addRule(".node > .debug-auto-hide:not(.node-debug-panel)", "visibility: visible")
      else
        sheet.deleteRule( rules.length - 1 )
