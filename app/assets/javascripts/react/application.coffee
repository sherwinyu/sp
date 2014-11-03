#= require utils/bs
window.sp ||= {}
rd = React.DOM
update = React.addons.update

{Link, Route, Routes, DefaultRoute} = ReactRouter

sp.ApplicationComponent = React.createClass

  getInitialState: ->
    notifications: []

  addNotification: (message) ->
    notifications = update(@state.notifications, $push: [message])
    @setState notifications: notifications

  renderNotifications: ->
    rd.div className: 'notifications',
      for notification in @state.notifications
        rd.div className: 'notification alert alert-success',
          notification
  render: ->
    rd.div className: 'container',
      @renderNotifications()
      @props.activeRouteHandler
        addNotification: @addNotification
