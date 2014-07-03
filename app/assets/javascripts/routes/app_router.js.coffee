#= require ./login_logout_route
#= require ./dashboard_route
#= require ./day_route

Sysys.Router.responseToString = (response) ->
  errorMsg = ""
  errorMsg += response.statusText + " "
  errorMsg += "(#{response.status}): "
  errorMsg += "#{response.responseText}"
  errorMsg += "[#{response.toString()}]"
  return errorMsg

Sysys.Router.map ->
  @resource "sexy_articles"

  @resource "data_point", path: "/data_point/:data_point_id", ->
    @route "new"

  @resource "data_points", path: "/data_points", ->
    @route  "new"

  @resource "rescue_time_dps", path: "/rtdps",  ->

  @resource "days", path: "/days", ->
    @route 'not_found', path: "/not_found/:day_id"

  @resource "day", path: "/days/:day_id", ->

  @route "notes"
  @route "dashboard"
  @route "login"
  @route "logout"

Sysys.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo "dashboard"

Sysys.ApplicationRoute = Ember.Route.extend
  _emberErrorToString: (error) ->
    errorMsg = error.message
    errorMsg += "Stack: "
    errorMsg += error.stack
    errorMsg

  actions:
    jsonChanged: (json)->

    # algorithm (for downPressed and upPressed):
    #   Find all elements with .line-item-selectable
    #   Find our elements position in that list
    #   Then get the next .line-item-selectable item
    #   And View.smartFocus it
    downPressed: (e)->
      elements = $('.line-item-selectable')
      idx = elements.index($(e.target).closest('.line-item-selectable'))
      return if idx == -1

      idx = (idx + elements.length + 1) % elements.length
      el = elements[idx]
      Ember.View.smartFocus el

    upPressed: (e)->
      elements = $('.line-item-selectable')
      idx = elements.index($(e.target).closest('.line-item-selectable'))
      return if idx == -1

      idx = (idx + elements.length - 1) % elements.length
      el = elements[idx]
      Ember.View.smartFocus el

    loading: (transition)->
      resource = transition.targetName.split(".")[0]
      dest = Em.String.classify(resource)
      @controllerFor('loading').set('destination', dest)
      true

    linkTo: (routeName, arg) ->
      @transitionTo routeName, arg


    error: (reason, transition) ->
      errorMsg = "Error:" # Params: #{JSON.stringify transition.params}"
      if reason instanceof Ember.Error
        errorMsg += @_emberErrorToString reason
      else
        errorMsg += " " + reason.statusText + " "
        errorMsg += " (#{reason.status}): "
        errorMsg += " #{reason.responseText}"

      @send 'notify', errorMsg
      @send 'debug', errorMsg

      if reason.status == 401
        @transitionTo "login"

    notify: (message) ->
      @controllerFor('notifications').addNotification message

    debug: (message) ->
      style = "color: orange; font-size: 16px"
      message = "#{utils.ts()} #{message}"
      console.info "%c#{message}", style

Sysys.LoadingRoute = Ember.Route.extend
  beforeModel: (transition) ->

  model: (args...)->

  setupController: (model, controller) ->

Sysys.LoadingController = Ember.ObjectController.extend
  destination: ""
  needs: "application"
