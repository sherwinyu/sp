#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require_tree ./humon
unless @Sysys then @Sysys = Ember.Application.create(
  autoinit: !Test
  )

Sysys.u =

  viewFromId: (id) ->
    Ember.get("Ember.View.views.#{id}")

  viewFromElement: (ele) ->
    Sysys.u.viewFromId($(ele).first().attr('id'))

  viewFromNumber: (num) ->
    Sysys.u.viewFromId("ember#{num}")

Sysys.vfi = Sysys.u.viewFromId
Sysys.vfe = Sysys.u.viewFromElement
Sysys.vf = Sysys.u.viewFromNumber
