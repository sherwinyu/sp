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

Sysys.ApplicationRoute = Ember.Route.extend
  actions:
    jsonChanged: (json)->

    downPressed: (e)->
      console.debug "downPressed"
      Ember.run.scheduleOnce "afterRender", @, =>
        elements = $('[tabIndex]')
        idx = elements.index(e.target)
        return if idx == -1
        idx = (idx + elements.length + 1) % elements.length
        console.debug "cross HEC focusing", elements[idx]
        elements[idx].focus()
    upPressed: (e)->
      console.debug "upPressed"
      Ember.run.scheduleOnce "afterRender", @, =>
        elements = $('[tabIndex]')
        idx = elements.index(e.target)
        return if idx == -1
        idx = (idx + elements.length - 1) % elements.length
        console.debug "cross HEC focusing", elements[idx]
        elements[idx].focus()
Sysys.IndexRoute = Ember.Route.extend
  actions:
    jsonChanged: ->
