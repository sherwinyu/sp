Sysys.Router.map ->
  @resource "dataPoint", path: "/data_point/:data_point_id", ->
    @route "new"
  @resource "dataPoints", path: "/data_points", ->
    @route  "new"

  @resource "acts", ->
    @route "new"
    @route "activeAct", path: 'activeAct/:act_id'

Sysys.DataPointRoute = Ember.Route.extend
  model: (params)->
     dpPromise = @get('store').find 'data_point', params.data_point_id

Sysys.DataPointIndexRoute = Ember.Route.extend()

Sysys.DataPointsRoute = Ember.Route.extend
  model: (params)->
     dpPromise = @get('store').findAll 'data_point'

Sysys.ActsRoute = Ember.Route.extend
  enter: ->
    console.log 'enter acts route'
  model: ->
    # Sysys.Act.find()
  events:
    wala: ->
      console.log @controllerFor('acts')
      console.log 'wala'


Sysys.ActsNewRoute = Ember.Route.extend
  model: ->

Sysys.ActsActiveActRoute = Ember.Route.extend
  enter: ->
    console.log 'enter acts active route'
  model: (params)->
    model = @controllerFor('acts').objectAt(0)
    console.log model, params
    model

Sysys.ActsIndexRoute = Ember.Route.extend
  model: ->

Sysys.ApplicationRoute = Ember.Route.extend
  actions:
    jsonChanged: (json)->
      5

    downPressed: (e)->
      elements = $('[tabIndex]')
      idx = elements.index(e.target)
      return if idx == -1
      idx = (idx + elements.length + 1) % elements.length
      elements[idx].focus()

    upPressed: (e)->
      elements = $('[tabIndex]')
      idx = elements.index(e.target)
      return if idx == -1
      idx = (idx + elements.length - 1) % elements.length
      elements[idx].focus()

  beforeModel: ->
  activate: ->
Sysys.IndexRoute = Ember.Route.extend
  actions:
    jsonChanged: ->
      5
