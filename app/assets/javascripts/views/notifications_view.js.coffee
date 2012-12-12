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
  add: (title, text, type) ->
    @content.pushObject Sysys.Notification.create( title: title, text: text, type: type )

  
  

Sysys.Notification = Ember.Object.extend
  text: null
  header: null
  type: null # 'INFO WARNING ERROR'


  init: ->
    @_super()
    unless @get('title') then @set('title', 'notification title')
    unless @get('text') then @set('text', 'notification text')
    unless @get('type') then @set('type', 'INFO')
  
Sysys.zorger = ->
  console.log 'zorging'
  

  
  
