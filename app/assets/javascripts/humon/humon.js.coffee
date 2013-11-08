#= require_self
#= require ./humon_node
#= require ./humon_utils
#= require ./humon_types
#= require ./humon_controller_mixin
window.Humon = Ember.Namespace.create
  _types: ["Number", "String", "List"]
  # _types: ["Number", "Boolean", "String", "List", "Hash"]
  #
Humon.HumonValue = Ember.Mixin.create
  name: ->
    @.constructor.toString().split(".")[1].toLowerCase()
  nextNode: ->
  prevNode: ->
  delete: ->
  toJson: (json)->

Humon.HumonValueClass = Ember.Mixin.create
  j2hnv: (json) ->
  matchesJson: (json) ->


Humon.Number = Ember.Object.extend Humon.HumonValue,
  _value: null
  toJson: ->
    @_value

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

  toJson: ->
    @_value

Humon.String.reopenClass
  j2hnv: (json, context) ->
    Humon.String.create(_value: json)
  matchesJson: (json) ->
    typeof json == "string"

Humon.List = Ember.Object.extend Humon.HumonValue, Ember.Array,
  _value: null
  toJson: ->
    ret = []
    for node in @_value
      ret.pushObject HumonUtils.node2json node
    ret
  replace: ()->
    true
    # TODO(syu): do shit

  objectAt: (i) ->
    @_value[i]

  unknownProperty: (key) ->
    @_value[key]


Humon.List.reopenClass
  j2hnv: (json, context) ->
    Em.assert( (json? && json instanceof Array), "json must be an array")
    # set all children node's `nodeParent` to this json payload's corresponding `node`
    childrenNodes = json.map( (x) -> HumonUtils.json2node(x, nodeParent: context.node))
    Humon.List.create
      _value: childrenNodes

  matchesJson: (json) ->
    json? and typeof json is 'object' and json instanceof Array and typeof json.length is 'number'
