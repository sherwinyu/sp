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
    for key in @constructor.requiredAttributes
      @ensure "Attribute `#{key}` is required", @get(key)
    for key in @get('children').mapProperty('nodeKey')
      @ensure "Attribute `#{key}` is not a valid child", @constructor.childMetatemplates[key]?

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

      newChildNode = Humon.json2node null, metatemplate: childMetatemplate, allowInvalid: true
      newChildNode.set "nodeKey", key
      @insertAt(idx, newChildNode)
      return newChildNode
    else
      null

)

Humon.Complex.reopenClass(
  childMetatemplates: {}
  requiredAttributes: []
  optionalAttributes: []
  directAttributes: []

  _metatemplate:
    $include: Humon.Hash._metatemplate
    $required: []

  # @param [JSON] context:
  #
  #  @required
  #  - node: the Humon.Node object that will wrap this Humon.Value
  #  - allowInvalid [boolean] if true, allows this node to be invalid
  #  - metatemplate
  #
  # The metatemplate corresponding to THIS PATH should be @_metatemplate
  # because THIS is already an instance of a Humon.*
  #
  # `childMetatemplates` is an available variable that contains metatemplates
  # for all childNodes.
  _j2hnv: (json, context) ->
    childNodes = []
    for own key, childVal of json
      Em.assert "Key `#{key}` is an invalid attribute for #{@}", @childMetatemplates[key]?
      childContext =
        nodeParent: context.node
        metatemplate: @childMetatemplates[key]
        allowInvalid: context.allowInvalid
      # Whose responsibility is it to make sure `childVal` is valid for @childMetatemplates[key] ?
      childNode = HumonUtils.json2node(childVal, childContext)
      childNode.set 'nodeKey', key
      childNodes.pushObject childNode
    @create _value: childNodes, node: context.node

  ##
  # TODO(syu): MatchesJson
  #   - make sure json is a hash
  #   - make sure all REQUIRE attributes are present
  #   - make sure all other keys are in OPTIONAL
  #   - does NOT check validate the values.

  ##
  # @override
  _initJsonDefaults: (json) ->
    @_super(json)

  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    console.warn "Coercing json #{JSON.stringify json} to #{@}"
    return {}
)
