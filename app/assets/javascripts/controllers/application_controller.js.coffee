Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  init: ->
    @set 'node', Sysys.j2hn [1,2,3]
    @set 'content', @get('node')
