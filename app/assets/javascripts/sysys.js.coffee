#= require_self
#= require ./store
#= require_tree ./utils
#= require ./humon/humon
#= require_tree ./humon_sysys
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
@Sysys = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_TRANSITIONS_INTERNAL: true
  LOG_VIEW_LOOKUPS: true
  LOG_ACTIVE_GENERATION: true

  customEvents: {
    testEvent: 'testEvent'
  }
Ember.onerror = (error) ->
  console.error error.toString()
  console.error error.stack()

