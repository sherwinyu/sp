Sysys.NotificationsController = Ember.ArrayController.extend
  actions:
    addNotification: (message) ->
      @addNotification(message)

    destroyNotification: (notification) ->
      @get('content').removeObject notification
    clearAll: ->
      @set('content', [])

  addNotification: (message) ->
    @get('content').pushObject Ember.Object.create message: message

  init: ->
    @set 'content', []

Sysys.NotificationsView = Ember.View.extend
  templateName: 'notifications'
  classNames: ['notifications']

Sysys.NotificationView = Ember.View.extend
  controller: null

  templateName: 'notification'
  classNames: ['alert']
  classNames: ['notification', 'alert']
  classNameBindings: ['type']
  type: (->
    'alert-warning'
    ###
    switch @get('context.type')
      when Sysys.Notification.INFO then 'alert-success'
      when Sysys.Notification.ERROR then 'alert-error'
      when Sysys.Notification.WARNING then ''
      else ''
    ###
  ).property('context.type')

  destroyNotification: (event) ->
    console.log('destroyNotification')
    @get('controller').remove(event.context)
