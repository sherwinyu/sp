#= require utils/bs
window.sp ||= {}
rd = React.DOM
update = React.addons.update

{Link, Route, Routes, DefaultRoute} = ReactRouter

sp.ApplicationComponent = React.createClass

  getInitialState: ->
    notifications: @props.notifications || []

  addNotification: (message) ->
    notifications = @state.notifications.slice(0)
    notifications.push message
    @setState notifications: notifications

  render: ->
    rd.div className: 'container',
      rd.div className: 'notifications',
        for notification in @state.notifications
          rd.div className: 'notification alert alert-success',
            notification
      @props.activeRouteHandler
        addNotification: @addNotification
