Sysys.NotificationsView = Ember.View.extend
  templateName: 'notifications'

Sysys.NotificationView = Ember.View.extend
  controller: null

  templateName: 'notification'
  classNames: ['alert']
  classNameBindings: ['type']
  type: (->
    switch @get('context.type')
      when Sysys.Notification.INFO then 'alert-success'
      when Sysys.Notification.ERROR then 'alert-error'
      when Sysys.Notification.WARNING then ''
      else '').property('context.type')
  init: ->
    @_super()
    # unless @get('controller')
      # TODO(syu) probably don't want to permanently set the notificationView.controller to notification_s_Controller
      # @set('controller', Sysys?.router?.get('notificationsController'))

  destroyNotification: (event) ->
    console.log('destroyNotification')
    @get('controller').remove(event.context)

Sysys.NotificationsController = Ember.ArrayController.extend
  content: null

  add: (title, text, type) ->
    @content.pushObject Sysys.Notification.create( title: title, text: text, type: type )

  addError: (title, text) ->
    @add(title, text, Sysys.Notification.ERROR)
  addInfo: (title, text) ->
    @add(title, text, Sysys.Notification.INFO)
  addWarning: (title, text) ->
    @add(title, text, Sysys.Notification.WARNING)

  remove: (notification)->
    @removeObject(notification)

  init: ->
    @_super()
    unless @get('content')?
      @set('content', [])

Sysys.Notification = Ember.Object.extend
  text: null
  type: null # one of 'INFO WARNING ERROR'


  init: ->
    @_super()
    unless @get('title') then @set('title', 'empty notification title')
    unless @get('text') then @set('text', 'empty notification text')
    unless @get('type') then @set('type', 'INFO')

Sysys.Notification.reopenClass(
  INFO: 'INFO'
  ERROR: 'ERROR'
  WARNING: 'WARNING'
)
