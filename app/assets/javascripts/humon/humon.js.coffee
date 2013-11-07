#= require_self
#= require ./humon_node
#= require ./humon_utils
#= require ./humon_types
#= require ./humon_controller_mixin
window.Humon =
  _types: ["Number", "String", "List"]
  # _types: ["Number", "Boolean", "String", "List", "Hash"]
  #
Humon.HumonValue = Ember.Mixin.create
  node: null
  nextNode: ->
  prevNode: ->
  delete: ->



Humon.Number = Ember.Object.extend Humon.HumonValue,
  _value: null
Humon.Number.reopenClass
  j2hnv: (json) ->
    Humon.Number.create(_value: json)
  matchesJson: (json) ->
    typeof json == "number"

Humon.String = Ember.Object.extend Humon.HumonValue,
  _value: null
  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  length: (->
    @get('_value').length
  ).property('_value')
Humon.String.reopenClass
  j2hnv: (json) ->
    Human.String.create(_value: json)
  matchesJson: (json) ->
    typeof json == "string"
