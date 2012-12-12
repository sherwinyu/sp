Sysys.NotificationsView = Ember.View.extend
  templateName: 'notifications'
  didInsertElement: ->
    debugger

Sysys.NotificationView = Ember.View.extend
  didInsertElement: ->

Sysys.NotificationsController = Ember.ArrayController.extend
  init: ->
    @_super()
    @set('content', [
      Sysys.Notification.create(),
      Sysys.Notification.create(),
      Sysys.Notification.create(),
    ])

  
  

Sysys.Notification = Ember.Object.extend
  text: null
  header: null
  type: null # 'INFO WARNING ERROR'

  init: ->
    @_super()
    @set('text', 'notification text')
    @set('title', 'notification title')
    @set('type', 'info')
  
Sysys.zorger = ->
  console.log 'zorging'
  

  
  
