React = require 'react'
rd = React.DOM
update = React.addons.update

ApplicationComponent = React.createClass

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

module.exports = ApplicationComponent
