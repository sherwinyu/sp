Sysys.NotificationsController = Ember.ArrayController.extend
  actions:
    addNotification: (message) ->
      @addNotification(message)

  addNotification: (message) ->
    @get('content').pushObject Ember.Object.create message: message

  init: ->
    @set 'content', []

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
      else ''
  ).property('context.type')

  destroyNotification: (event) ->
    console.log('destroyNotification')
    @get('controller').remove(event.context)
