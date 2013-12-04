Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  init: ->
    @set 'node', Humon.json2node
      abc: 123
      waga: [1,2,3, 4]
    @set 'content', @get('node')
