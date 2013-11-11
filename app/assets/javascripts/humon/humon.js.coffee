#= require_self
#= require ./node
#= require ./humon_utils
#= require ./template_contexts
#= require ./humon_controller_mixin

window.Humon = Ember.Namespace.create
  _types: ["Number", "Boolean", "Null", "Date", "String", "List", "Hash"]

  contextualize: (type) ->
    if type.constructor == Humon.Node
      type = type.get('nodeType')
    key = type[0].toUpperCase() + type.slice(1)
    Humon[key] || Em.assert("Could not find type Humon.#{key}")

  templateContextFor: (type) ->
    if type.constructor == Humon.Node
      type = type.get('nodeType')
    key = type
    key = type[0].toUpperCase() + type.slice(1)
    ctx = Humon.TemplateContexts[key] || Humon.TemplateContext
    ctx.create()

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

Humon.Primitive = Ember.Object.extend Humon.HumonValue,
  _value: null

  # TODO(syu): @TRANSITION
  isLiteral: true

  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  toJson: ->
    @_value
  asString: ->
    @toJson()
  nextNode: ->
  flatten: ->
    [@node]

Humon.Primitive.reopenClass
  _klass: ->
    @
  _name: ->
    @_klass().toString().split(".")[1].toLowerCase()
  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  j2hnv: (json, context) ->
    @_klass().create(_value: json, node: context.node)
  matchesJson: (json) ->
    typeof json == @_name()


Humon.Number = Humon.Primitive.extend()

Humon.String = Humon.Primitive.extend
  length: (->
    @get('_value').length
  ).property('_value')


Humon.Boolean = Humon.Primitive.extend()
Humon.Null = Humon.Primitive.extend()
Humon.Null.reopenClass
  matchesJson: (json) ->
    json == null

Humon.Date = Humon.Primitive.extend()
Humon.Date.reopenClass
  _momentFormatTransforms:
    'ddd MMM D': (string, format) ->
      @_momentFormatAndValidate string, format
    'ddd MMM D YYYY': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY MM DD': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY M D': (string, format)->
      @_momentFormatAndValidate string, format
    _momentFormatAndValidate: (string, format) ->
      date = @_momentFormat(string, format).toDate()
      valid = !isNaN(date.getTime()) && moment(date).format(format) == string
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

  _inferAsMomentValidDate: (string) ->
    moment(string).isValid() && moment(string).toDate()

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
    try
      ret ||= (typeof json is "object" && json.constructor == Date && json)
      # ret ||= @_inferViaDateParse(json)
      ret ||= json.constructor == String && @_inferAsMomentFormat(json)
      ret ||= json.constructor == String && @_inferAsMomentValidDate(json)
    catch error
      console.error error.toString()
      ret = false
    finally
      ret

  j2hnv: (json, context) ->
    value = @_inferFromJson(json)
    Humon.Date.create(_value: value, node: context.node)
  matchesJson: (json) ->
    !!@_inferFromJson(json)

Humon.List = Ember.Object.extend Humon.HumonValue, Ember.Array,
  _value: null
  isCollection: true
  isList: true
  toJson: ->
    ret = []
    for node in @_value
      ret.pushObject HumonUtils.node2json node
    ret

  children: (->
    @get('_value')
  ).property('_value', '_value.@each')

  # @return [Humon.Node] Returns a flat representation of
  flatten: ->
    @get('_value').reduce (flattened, node) ->
      flattened.concat(node.flatten())
    , [@.node]

  replace: ()->
    throw new Error "Not implemented yet"
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
    Humon.List.create _value: childrenNodes, node: context.node
  matchesJson: (json) ->
    json? and typeof json is 'object' and json instanceof Array and typeof json.length is 'number'

Humon.Hash = Humon.List.extend
  isHash: true
  isList: false

  # @param keyOrIndex the value to access
  # attempts to do a look up against _value
  # If the key is a number of a numeric string, look up by index
  # Otherwise, look up by childNode's nodeKey
  unknownProperty: (keyOrIndex) ->
    # If it's a string, look up by key
    if isNaN(keyOrIndex) && keyOrIndex.constructor == String
      @_value.findProperty('nodeKey', keyOrIndex)
    # If it's a number (or numeric string), look up by index
    else if !isNaN(keyOrIndex)
      @_value[keyOrIndex]
    else
      throw new Error "invalid key or index #{keyOrIndex}"

  toJson: ->
    ret = {}
    for node in @_value
      key = node.get('nodeKey')
      key ?= @_value.indexOf node
      ret[key] = HumonUtils.node2json node
    ret

Humon.Hash.reopenClass
  # @param json the json payload to convert into a HumonValue
  # @context a context object with keys:
  #   - node: the node that will be containing the nodeValue corresponding to `json`
  # @returns Humon.Hash
  #
  # Returns a Humon.Hash whose child key-value pairs are set to the corresponding
  # key-values pairs in `json`, generated by calling `Utils.json2node` on the json val.
  # Each of the children are HumonNodes.
  # Each HumonNode has `nodeParent` set to `context.node`
  j2hnv: (json, context)->
    childNodes = []
    for own key, childVal of json
      childNode = HumonUtils.json2node(childVal, nodeParent: context.node)
      childNode.set 'nodeKey', key
      childNodes.pushObject childNode
    Humon.Hash.create _value: childNodes, node: context.node

  # @param json the json payload to test
  # returns true if this is a POJO
  matchesJson: (json) ->
    json? and (typeof json is 'object') and !(json instanceof Array) and json.constructor == Object
