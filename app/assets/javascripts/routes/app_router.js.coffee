window.delay_param = 250

responseToString = (response) ->
  errorMsg = ""
  errorMsg += response.statusText + " "
  errorMsg += "(#{response.status}): "
  errorMsg += "#{response.responseText}"
  errorMsg += "[#{response.toString()}]"
  return errorMsg

slowPromise = ->

  new Ember.RSVP.Promise((resolve) ->
    setTimeout (->
      resolve [
        title: "a"
      ,
        title: "b"
      ,
        title: "c"
      ]
    ), 2500
  )

delayed = (ftn) ->
  Ember.RSVP.Promise (resolve) ->
    setTimeout (->
      resolve ftn.call(null)
    ), window.delay_param

Sysys.Router.map ->
  @resource "sexy_articles"

  @resource "data_point", path: "/data_point/:data_point_id", ->
    @route "new"

  @resource "data_points", path: "/data_points", ->
    @route  "new"

  @resource "rescue_time_dps", path: "/rtdps", ->

  @resource "days", path: "/days", ->
    @route 'not_found', path: "/not_found/:day_id"

  @resource "day", path: "/days/:day_id", ->

  @route "dashboard"

Sysys.SexyArticlesRoute = Ember.Route.extend
  model: slowPromise

Sysys.DashboardRoute = Ember.Route.extend
  model: ->
    dayPromise = @get('store').find 'day', 'latest'

  setupController: (controller, model) ->
    @controllerFor('day').set('model', model)

  renderTemplate: ->
    @_super()
    @render 'day',
      into: 'dashboard'
      outlet: 'day'
      controller: @controllerFor('day')

Sysys.DaysRoute = Ember.Route.extend
  model: (params) ->
    daysPromise = @get('store').findAll 'day'

  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'days'


Sysys.DayRoute = Ember.Route.extend
  model: (params) ->
    dayPromise = @get('store').find 'day', params.day_id

  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'day', day: model.get('id')

  actions:
    error: (reason, transition) ->
      console.error "Error!", reason.toString(), reason.stack

      errorMsg = "Error on #{transition.params.day_id}"
      errorMsg += responseToString reason

      @send 'notify', errorMsg

      if reason.statusText == 'Not Found'
        day = @get('store').createRecord 'day' #id: transition.params.day_id
        day.set 'date', transition.params.day_id
        @transitionTo 'days.not_found', day

Sysys.DaysNotFoundRoute = Ember.Route.extend
  serialize: (model, params)->
    return day_id: model.get('date')

  model: (params)->
    day = @get('store').createRecord 'day' #id: transition.params.day_id
    day.set 'date', params.day_id

  renderTemplate: ->
    @render 'days/not_found',
        into: 'application'

  actions:
    initializeDay: (day) ->
      success = (day) => @transitionTo 'day', day
      failure = (response) => @send 'notify', responseToString response
      day.save().then success, failure

Sysys.DataPointRoute = Ember.Route.extend
  model: (params)->
   dpPromise = @get('store').find 'data_point', params.data_point_id
  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'data_point', data_point: model.get('id')

Sysys.DataPointIndexRoute = Ember.Route.extend()

Sysys.DataPointsRoute = Ember.Route.extend
  model: (params)->
   dpsPromise = @get('store').findAll 'data_point'
  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'data_points'

Sysys.RescueTimeDpsRoute = Ember.Route.extend
  model: (params)->
     rtdpPromise = @get('store').findAll 'rescue_time_dp'
  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'rescue_time_dps'

Sysys.RescueTimeDpsIndexRoute = Ember.Route.extend()

Sysys.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo "dashboard"


Sysys.ApplicationRoute = Ember.Route.extend
  actions:
    jsonChanged: (json)->


    # algorithm:
    #   find all elements with [tabIndex] set
    #   then convert each of those elements to the nearest humon node element
    #   then fire smartFocus on the corresponding humon node view
    downPressed: (e)->
      elements = $('[tabIndex]').closest('.node')
      idx = elements.index($(e.target).closest('.node'))
      return if idx == -1
      idx = (idx + elements.length + 1) % elements.length

      el = elements[idx]
      Sysys.vfi($(el).attr('id')).smartFocus()

    upPressed: (e)->
      elements = $('[tabIndex]').closest('.node')
      idx = elements.index($(e.target).closest('.node'))
      return if idx == -1
      idx = (idx + elements.length - 1) % elements.length

      el = elements[idx]
      Sysys.vfi($(el).attr('id')).smartFocus()

    loading: (transition)->
      resource = transition.targetName.split(".")[0]
      dest = Em.String.classify(resource)
      @controllerFor('loading').set('destination', dest)
      true

    linkTo: (routeName, arg) ->
      @transitionTo routeName, arg

    error: (reason, transition) ->
      errorMsg = "ApplicationRoute#error. Params: #{JSON.stringify transition.params}"
      errorMsg += reason.statusText + " "
      errorMsg += "(#{reason.status}): "
      errorMsg += "#{reason.responseText}"
      errorMsg += "[#{reason.toString()}]"

      @send 'notify', errorMsg

    notify: (message) ->
      style = "color: orange; font-size: x-large"
      message = "#{utils.ts()} #{message}"
      console.info "%c#{message}", style

Sysys.LoadingRoute = Ember.Route.extend
  beforeModel: (transition) ->

  model: (args...)->

  setupController: (model, controller) ->

Sysys.LoadingController = Ember.ObjectController.extend
  destination: ""
  needs: "application"
