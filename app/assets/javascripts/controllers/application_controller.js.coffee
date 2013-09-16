Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  init: ->
    @set 'node', Sysys.j2hn
      abc: 123
      waga: [1,2,3, 4]
    @set 'content', @get('node')
  actions:
    downPressed: ->
      debugger
    upPressed: ->
      debugger
