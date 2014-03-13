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

  @resource "rescue_time_dps", path: "/rtdps",  ->

  @resource "days", path: "/days", ->
    @route 'not_found', path: "/not_found/:day_id"

  @resource "day", path: "/days/:day_id", ->

  @route "dashboard"
  @route "login"
  @route "logout"


Sysys.SexyArticlesRoute = Ember.Route.extend
  model: slowPromise

Sysys.LoginRoute = Ember.Route.extend
  beforeModel: (transition) ->
    if @controllerFor('auth').get('isSignedIn')
      @transitionTo "dashboard"
  model: -> Ember.Object.create()
  actions:
    login: (credentials) ->
      @controllerFor("auth").login credentials

Sysys.LogoutRoute = Ember.Route.extend
  beforeModel: ->
    logout = utils.delete
      url: "users/sign_out.json"
    logout.then ->
      location.reload()

Sysys.DashboardRoute = Ember.Route.extend
  model: ->
    dayPromise = @get('store').find 'day', 'latest'

  setupController: (controller, model) ->
    @controllerFor('day').set('model', model)

    rtdpsController = @controllerFor('rescue_time_dps')
    rtdpsController.set 'start', moment().subtract(24, 'hours')
    rtdps = @store.filter 'rescue_time_dp', {nargle: true}, (rtdp) ->
      rtdpsController.rtdpWithinTimeRange(rtdp)
    rtdpsController.set('model', rtdps)

    acts = @store.findAll 'act'
    actsController = @controllerFor 'acts'
    actsController.set 'model', acts

  renderTemplate: ->
    @_super()
    @render 'day',
      into: 'dashboard'
      outlet: 'day'
      controller: @controllerFor('day')
    @render 'rescue_time_dps',
      into: 'dashboard'
      outlet: 'rescue_time_dps'
      controller: @controllerFor('rescue_time_dps')
    @render 'acts',
      into: 'dashboard'
      outlet: 'acts'
      controller: @controllerFor('acts')

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

      @send 'debug', errorMsg

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
      failure = (response) => @send 'debug', responseToString response
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
  model: (params, transition)->
     rtdpPromise = @get('store').findAll 'rescue_time_dp'

  afterModel: (resolvedModel, transition) ->
    utils.track "visit", route: 'rescue_time_dps'

Sysys.RescueTimeDpsIndexRoute = Ember.Route.extend()

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
