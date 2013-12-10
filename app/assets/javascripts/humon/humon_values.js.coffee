#= require_self
#= require ./humon_primitive
#= require ./humon_list
#= require ./humon_hash
#= require ./humon_complex
#= require ./humon_sleep
#= require ./humon_day_summary
#= require ./humon_time

Humon.HumonValue = Ember.Mixin.create
  name: ->
    # TODO(syu): test this
    # TODO(syu): switch over to using the underscored version
    Ember.String.underscore @.constructor.toString().split(".")[1]
    # @.constructor.toString().split(".")[1].toLowerCase()
  asString: ->
  nextNode: ->
  prevNode: ->
  delete: ->
  ##
  # @return [JSON] json
  toJson: ->
  node: null

Humon.HumonValueClass = Ember.Mixin.create
  j2hnv: (json) ->
  matchesJson: (json) ->
