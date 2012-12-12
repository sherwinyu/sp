Sysys.ActsController = Ember.ArrayController.extend
  notifications: null
  init: ->
    @_super()
    @set('notifications', [5,6,7])
