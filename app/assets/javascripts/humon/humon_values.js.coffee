#= require_self
#= require ./humon_primitive
#= require ./humon_list
#= require ./humon_hash
#= require ./humon_complex
#= require ./humon_sleep
#= require ./humon_time

Humon.HumonValue = Ember.Mixin.create
  name: ->
    @.constructor.toString().split(".")[1].toLowerCase()
  asString: ->
  nextNode: ->
  prevNode: ->
  delete: ->
  toJson: ->
  node: null

Humon.HumonValueClass = Ember.Mixin.create
  j2hnv: (json) ->
  matchesJson: (json) ->
