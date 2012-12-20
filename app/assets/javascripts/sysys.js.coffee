#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
unless @Sysys then @Sysys = Ember.Application.create(
  autoinit: !Test
  )
