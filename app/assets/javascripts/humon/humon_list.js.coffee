Humon.List = Humon.BaseHumonValue.extend Humon.HumonValue, Ember.Array,
  _value: null
  isCollection: true
  childrenReorderable: true
  acceptsArbitraryChildren: true
  isList: true
  isLiteral: false
  hasKeys: false
  asString: -> JSON.stringify(@toJson())

  length: (->
    @get('_value').length
  ).property('_value')

  hasChildren: ( ->
    @_value.length >= 1
  ).property('children')

  toJson: ->
    ret = []
    for node in @_value
      ret.pushObject HumonUtils.node2json node
    ret

  children: (->
    @get('_value')
  ).property('_value', '_value.@each')

  validateSelf: ->
    @ensure "_value is an array", @_value instanceof Array

  ##
  # @override
  # @manipulatesUI
  enterPressed: (e, payload)->
    return if e._handled?
    newChildNode = null
    Ember.run => newChildNode = @insertNewChildAt(0)
    if newChildNode?
      @get('controller').send 'activateNode', newChildNode
      @get('controller').send 'smartFocus'

    # Returns false, to prevent NodeView#enterPressed from happening
    return false

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

  replaceAt: (idx, amt, nodes...) ->
    children = @get('children')

    # set the `nodeParent` for the removed nodes to null
    end = Math.min(idx + amt, children.length)
    for i in [idx...end]
      children[i]?.set('nodeParent', null)

    # set the nodeParent for the inserted nodes to this node
    if nodes?
      for node in nodes
        node.set('nodeParent', @get('node'))

    children.replace idx, amt, nodes

  insertAt: (idx, nodes...) ->
    args = [idx, 0].concat nodes
    @replaceAt.apply @, args

  ##
  # @param [int] idx
  # @return [Humon.Node]
  #
  # Does NOT manipulate the UI, only the node chain.
  insertNewChildAt: (idx) ->
    blank = Humon.json2node null, nodeParent: @node
    @insertAt(idx, blank)
    return blank

  deleteAt: (idx, amt) ->
    amt ?= 1
    @replaceAt(idx, amt)

  deleteChild: (node) ->
    idx = node.get('nodeIdx')
    @deleteAt(idx)

Humon.List.reopenClass
  childMetatemplates: {}

  ##
  # @override
  _j2hnv: (json, context) ->
    value = @valueFromJson(json, context)
    @create(_value: value, node: context.node)

  ##
  # @override
  # @param json
  # @param context
  #   - node [Humon.Node] the wrapping node for this list value
  # @return [Array<Humon.Node>]
  valueFromJson: (json, context) ->
    Em.assert( (json? && json instanceof Array), "json must be an array")
    childNodes = json.map( (x) => @_j2childNode(x, context))
    return childNodes

  ##
  # @param childJson
  # @param parentContext [JSON] context object from the parent (current List)
  # @return [Humon.Node] a Node representing the child, with parent and metatemplate correctly set .
  _j2childNode: (childJson, parentContext) ->
    childContext =
      nodeParent: parentContext.node
      metatemplate: @childMetatemplates.$each
      allowInvalid: parentContext.allowInvalid
    return HumonUtils.json2node(childJson, childContext)

  ##
  # @override
  matchesJson: (json) ->
    json? and typeof json is 'object' and json instanceof Array and typeof json.length is 'number'

  # precondition: matchesJson was false
  _baseJson: (json) ->
    []
