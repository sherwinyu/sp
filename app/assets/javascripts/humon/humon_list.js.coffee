Humon.List = Ember.Object.extend Humon.HumonValue, Ember.Array,
  _value: null
  isCollection: true
  childrenReorderable: true
  acceptsArbitraryChildren: true

  hasChildren: ( ->
    @_value.length >= 1
  ).property('children')
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
