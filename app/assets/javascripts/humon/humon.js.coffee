#= require_self
#= require ./humon_node
#= require ./humon_utils
#= require ./humon_types
#= require ./humon_types_date
#= require ./humon_controller_mixin
window.Humon = Ember.Namespace.create
  _types: ["Number", "Boolean", "Date", "String", "List"]
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



Humon.Boolean = Ember.Object.extend Humon.HumonValue,
  _value: null
  toJson: ->
    @_value
Humon.Boolean.reopenClass
  j2hnv: (json, context) ->
    Humon.Boolean.create(_value: json)
  matchesJson: (json) ->
    typeof json == "boolean"



Humon.Date = Ember.Object.extend Humon.HumonValue,
  _value: null
  toJson: ->
    @_value
Humon.Date.reopenClass
  _momentFormatTransforms:
    'ddd MMM D': (string, format) ->
      @_momentFormatAndValidate string, format
    'ddd MMM D YYYY': (string, format)->
      @_momentFormatAndValidate string, format
    _momentFormatAndValidate: (string, format) ->
      date = @_momentFormat(string, format).toDate()
      valid = Date.parse(string).equals date
      {valid: valid, date: date}
    _momentFormat: (string, format) ->
      mmt = moment(string, format)


  _inferAsMomentFormat: (string) ->
    return false if string.constructor != String
    for format, transform of @_momentFormatTransforms
      {valid, date} = @_momentFormatTransforms[format](string, format)
      if valid
        return date
    false

  # _inferFromJson -- attempts to convert a json value to this type
  #   param json json: the candidate json object
  #   return: if successful, a value of this type
  #           if unsuccessful, a falsy value
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # type registration order (calls to HumonType.register)
  #
  # TODO(syu): update and generalize to work for all humon types and include it in
  # the standard suite. AKA make it work for booleans: return a hash {matchesType, value}
  # problem is that right now yu can't distinguish between a literal false and a false as in failure
  _inferFromJson: (json) ->
    ret = false
    ret ||= (typeof json is "object" && json.constructor == Date && json)
    ret ||= @_inferAsMomentFormat(json)
    ret

  j2hnv: (json, context) ->
    value = @_inferFromJson
    Humon.Date.create(_value: value)
  matchesJson: (json) ->
    !!@_inferFromJson(json)



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



