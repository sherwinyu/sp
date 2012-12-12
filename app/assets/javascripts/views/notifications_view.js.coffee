Sysys.NotificationsView = Ember.View.extend
  templateName: 'notifications'

Sysys.NotificationView = Ember.View.extend
  classNames: ['alert']
  classNameBindings: ['type']
  type: (->
    switch @content.get('type')
      when 'INFO' then 'alert-success'
      when 'ERROR' then 'alert-error'
      when 'WARNING' then ''
      else '').property('content.type')

  isInfo: (->
    @content.get('type') == 'INFO').property('content.type')

  isError: (->
    @content.get('type') == 'ERROR').property('content.type')

  isWarning: (->
    @content.get('type') == 'WARNING').property('content.type')

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
    @set('type', 'INFO')
  
Sysys.zorger = ->
  console.log 'zorging'
  

  
  
