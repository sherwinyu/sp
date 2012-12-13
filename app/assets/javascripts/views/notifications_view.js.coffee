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

  addError: (title, text) ->
    @add(title, text, 'ERROR')
  addInfo: (title, text) ->
    @add(title, text, 'INFO')
  addWarning: (title, text) ->
    @add(title, text, 'WARNING')

  remove: (e)->
    @content.removeObject(e.context)

Sysys.Notification = Ember.Object.extend
  text: null
  header: null
  type: null # one of 'INFO WARNING ERROR'


  init: ->
    @_super()
    unless @get('title') then @set('title', 'empty notification title')
    unless @get('text') then @set('text', 'empty notification text')
    unless @get('type') then @set('type', 'INFO')
