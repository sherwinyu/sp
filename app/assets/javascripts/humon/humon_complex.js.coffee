Humon.Complex = Humon.Hash.extend(
  isComplex: true
  isCollection: true
  childrenReorderable: false
  acceptsArbitraryChildren: false
  hasKeys: true

  optionalChildren: (->
    @get('children').filter (node) => node.get('nodeKey') in @constructor.optionalAttributes
  ).property('children', 'children.@each.nodeKey')

  requiredChildren: (->
    @get('children').filter (node) => node.get('nodeKey') in @constructor.requiredAttributes
  ).property('children', 'children.@each.nodeKey')

  ##
  # @override
  # For every required attribute, make sure a node is present
  # For every attribute, make sure its in childMetatemplates
  validateSelf: ->
    # for key in @constructor.requiredAttributes
    # @ensure "Attribute `#{key}` is required", @get(key)
    for key in @get('children').mapProperty('nodeKey')
      @ensure "Attribute `#{key}` is not a valid child", @constructor.childMetatemplates[key]?
    @_super()

  ##
  # Automatically finds the first optional attribute that isn't included yet, and inserts that.
  # The childNode is inserted with allowInvalid: true
  #
  # @param [int] idx the index at which to insert.
  #   This is currently ignored because Humon.Complex will try to insert the children in proper
  #   attribute order
  # @return [Humon.Node] the inserted childNode
  #   or null, if all optional attributes already exist
  # @override
  insertNewChildAt: (idx) ->

    # Get an array of unused attribute keys
    unusedAttributeKeys = @constructor.optionalAttributes.filter( (key) =>
      @get(key) == undefined)

    # If there are still unused attributes
    if (key = unusedAttributeKeys[0])?

      # TODO(syu): Wow this is so ugly
      idx = @get('requiredChildren').length + @constructor.optionalAttributes.indexOf key
      childMetatemplate = @constructor.childMetatemplates[key]

      newChildNode = Humon.json2node null, metatemplate: childMetatemplate, allowInvalid: true, nodeParent: @node
      newChildNode.set "nodeKey", key
      @insertAt(idx, newChildNode)
      return newChildNode
    else
      null

  deleteChild: (node) ->
    console.warn "Node #{@} attempting to deleteChild but node #{node} is not a child" unless node in @get('children')
    return if node in @get 'requiredChildren'
    @_value.removeObject(node)


  unknownProperty: null

  ##
  # _getChildByKey and _setChildByKey exist as a shim over different
  # underlying implementations.
  # So complex is currently implemented as an array, but Humon.valAttr doesn't need to know that;
  # instead it can just rely on _getChildByKey and _setChildByKey
  _getChildByKey: (key) ->
    @_value.findProperty('nodeKey', key)
  ##
  # @param key [string] key
  # @param node [Humon.Node] value
  #
  # Used by the Humon.valAttr computed property
  _setChildByKey: (key, node) ->
    Em.assert "Node #{node} must be of type Humon.Node", node instanceof Humon.Node
    # remove it:
    oldNode = @_value.findProperty('nodeKey', key)
    if oldNode?
      @_value.removeObject(oldNode)
    @_value.pushObject node

)

Humon.Complex.reopenClass(
  childMetatemplates: {}
  requiredAttributes: []
  optionalAttributes: []
  directAttributes: []

  matchesJson: (json) ->
    # Make sure it's a hash first.
    return false unless @_super(json)

    for key in @requiredAttributes
      return false unless key of json
      # TODO(syu): Check the actual values of the keys
      # and that they belong to the metatemplate.
    for key of json
      return false unless @childMetatemplates[key]?
    return true

  valueFromJson: (json, context) ->
    childNodes = []
    # Safety check to make sure json isn't being passed invalid attributes
    for key of json
      Em.assert "Key `#{key}` is an invalid attribute for #{@}", @childMetatemplates[key]?

    for key of @childMetatemplates
      # Skip unless the json specified this key.
      # Note that we don't skip when json[key] is (explicitly) undefined
      continue unless key of json

      childVal = json[key]
      childContext =
        nodeParent: context.node
        metatemplate: @childMetatemplates[key]
        allowInvalid: context.allowInvalid
      # Whose responsibility is it to make sure `childVal` is valid for @childMetatemplates[key] ?
      childNode = HumonUtils.json2node(childVal, childContext)
      childNode.set 'nodeKey', key
      childNodes.pushObject childNode

    return childNodes

  _baseJson: (json) ->
    json = {} unless Humon.Hash.matchesJson(json)
    for key in @requiredAttributes
      # TODO(syu): initialize values to the corresponding
      #   typeClass._baseJson(json[key])
      ###
      typeClass = @childMetatemplate[key].name
      if typeClass?
        json[key] ?=
      ###
      json[key] ?= undefined
    for key of json
      delete json[key] unless @childMetatemplates[key]?
    json

  ##
  # Reopens the class, adding computed properties (as instance methods) for
  # `<key>` and `_<key>`
  #  - nodeVal.<key> [Humon.Node] returns the child node belonging to `key`
  #  - nodeVal._<key> [JSON] returns underlying json representation to node at `key`
  _generateAccessors: ->
    for key of @childMetatemplates
      methods = {}
      methods[key] = Humon.valAttr(key)
      methods["_" +key] = Humon.nodeAttr(key)
      @reopen methods

)
