React = require 'react'
ReactRouter = require 'react-router'

RouteHandler = ReactRouter.RouteHandler

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
      RouteHandler
        addNotification: @addNotification

module.exports = ApplicationComponent
