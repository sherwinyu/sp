#= require utils/bs
#= require utils/react
#= require react/application
#= require react/activity
#= require react/resolutions/resolutions_index
#= require react/json_editor

React = require 'react'
ReactRouter = require 'react-router'
ApplicationComponent = require 'react/application'
{Activity, ActivitiesIndex} = require 'react/activity'
ResolutionsIndex = require 'react/resolutions/resolutions_index'
JsonEditorRoot = require 'react/json_editor'

rd = React.DOM
update = React.addons.update
{Link, Route} = ReactRouter

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


$(document).ready ->

  routes =
    Route name: 'application', path: '/', handler: ApplicationComponent,
      Route
        name: 'activities',
        path: '/activities',
        handler: ActivitiesIndex,
      ,
        Route
          name: 'activity'
          path: ':activityId'
          handler: Activity

      Route
        name: 'json_editor'
        path: '/json_editor'
        # initialValue: [1,2,3]
        initialValue:
          a: 5
          b: [1,2,3]
          d:
            f: 'asdf'
        handler: JsonEditorRoot

      Route
        name: 'resolutions'
        path: '/resolutions'
        handler: ResolutionsIndex

  ReactRouter.run routes, ReactRouter.HistoryLocation, (handler) ->
    React.render handler(), $('.react-mount')[0]
