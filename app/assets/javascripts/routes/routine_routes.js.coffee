Sysys.RoutinesRoute = Ember.Route.extend
  model: (params)->
    x = $.getJSON('/routines').then (root)->
      root.routines
