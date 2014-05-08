Sysys.RoutinesRoute = Ember.Route.extend
  model: (params)->
    $.getJSON('/routines')
