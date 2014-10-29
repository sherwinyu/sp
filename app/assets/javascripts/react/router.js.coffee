#= require utils/bs
#= require react/application
#= require react/activity

$(document).ready ->
  $.ajaxSetup
    headers:
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

jQuery.extend
  putJSON: (url, data, callback) ->
    data = $.extend {'_method': 'put'}, data
    $.ajax
      type: 'post'
      headers:
        'X-Http-Method-Override': 'put'
      url: url
      data: JSON.stringify data
      success: callback
      contentType: 'application/json'
      dataType: 'json'

window.sp ||= {}
rd = React.DOM
update = React.addons.update

{Link, Route, Routes, DefaultRoute} = ReactRouter

$(document).ready ->

  routes = Routes location: 'history',
      Route
        name: 'application'
        path: '/'
        handler: sp.ApplicationComponent
        notifications: []
      ,
        Route
          name: 'activities',
          path: '/activities',
          handler: sp.ActivitiesIndex,
          mostUsedActivities: window._sp_vars.props.activities
        ,
          Route
            name: 'activity'
            path: ':activityId'
            handler: sp.Activity

  props = window._sp_vars.props
  React.renderComponent(routes, $('.react-mount')[0])
