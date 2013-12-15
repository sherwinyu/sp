Humon.List = Humon.BaseHumonValue.extend Humon.HumonValue, Ember.Array,
  _value: null
  isCollection: true
  childrenReorderable: true
  acceptsArbitraryChildren: true
  isList: true
  hasKeys: false

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


  ##
  # @override
  enterPressed: (e)->
    newChildNode = @insertNewChildAt(0)
    if newChildNode?
      @get('controller').send 'activateNode', newChildNode
      @get('controller').send 'smartFocus'

    # suppress default behavior
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

  # @param [int] idx
  # @return [Humon.Node]
  insertNewChildAt: (idx) ->
    blank = Humon.json2node null
    @insertAt(idx, blank)
    return blank

  deleteAt: (idx, amt) ->
    amt ?= 1
    @replaceAt(idx, amt)

  deleteChild: (node) ->
    idx = node.get('nodeIdx')
    @deleteAt(idx)

Humon.List.reopenClass
  j2hnv: (json, context) ->
    json = @normalizeJson(json, typeName: context?.metatemplate?.name)

    Em.assert( (json? && json instanceof Array), "json must be an array")

    # set all children node's `nodeParent` to this json payload's corresponding `node`
    childrenNodes = json.map( (x) -> HumonUtils.json2node(x, nodeParent: context.node))
    @create _value: childrenNodes, node: context.node

  ##
  # @override
  matchesJson: (json) ->
    json? and typeof json is 'object' and json instanceof Array and typeof json.length is 'number'

  _initJsonDefaults: (json) ->
    json ||= []
