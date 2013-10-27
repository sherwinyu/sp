Sysys.Router.map ->
  @resource "dataPoint", path: "/data_point/:data_point_id", ->
    @route "new"

  @resource "dataPoints", path: "/data_points", ->
    @route  "new"

  @resource "acts", ->
    @route "new"
    @route "activeAct", path: 'activeAct/:act_id'

  @resource "rescueTimeDps", path: "/rtdps", ->
    @route "new"

  @resource "days", path: "/days", ->
    @resource "day", path: "/:day_id"


Sysys.DaysRoute = Ember.Route.extend
  model: (params) ->
    daysPromise = @get('store').findAll 'sp_day'

  ativate: ->
    utils.track("days activate")

Sysys.DayRoute = Ember.Route.extend
  model: (params) ->
    daysPromise = @get('store').find 'sp_day', params.day_id

  ativate: ->
    utils.track("day activate")

Sysys.DataPointRoute = Ember.Route.extend
  model: (params)->
     dpPromise = @get('store').find 'data_point', params.data_point_id
  activate: ->
    utils.track("data point activate")

Sysys.DataPointIndexRoute = Ember.Route.extend()

Sysys.DataPointsRoute = Ember.Route.extend
  model: (params)->
     dpPromise = @get('store').findAll 'data_point'
  activate: ->
    utils.track("data points activate")

Sysys.RescueTimeDpsRoute = Ember.Route.extend
  model: (params)->
     rtdpPromise = @get('store').findAll 'rescue_time_dp'
  activate: ->
    utils.track("rescue time dps activate")

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
      Sysys.vfi($(elements[idx]).attr('id')).smartFocus()

    upPressed: (e)->
      elements = $('[tabIndex]').closest('.node')
      idx = elements.index($(e.target).closest('.node'))
      return if idx == -1
      idx = (idx + elements.length - 1) % elements.length
      Sysys.vfi($(elements[idx]).attr('id')).smartFocus()

Sysys.IndexRoute = Ember.Route.extend
  actions:
    jsonChanged: ->
