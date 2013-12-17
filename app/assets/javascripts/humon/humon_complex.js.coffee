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

  # @param [int] idx the index at which to insert.
  # @return [Humon.Node] the inserted childNode
  # @override
  #   or null, if all optional attributes already exist
  # Automatically finds the first optional attribute
  # that isn't included yet, and inserts that.
  #
  # TODO(syu): ignore idx and insert the proper child
  insertNewChildAt: (idx) ->
    # Get an array of unused attribute keys
    unusedAttributeKeys = @constructor.optionalAttributes.filter( (key) =>
      @get(key) == undefined)
    if (key = unusedAttributeKeys[0])?

      # TODO(syu): Wow this is so ugly
      idx = @get('requiredChildren').length + @constructor.optionalAttributes.indexOf key
      childMetatemplate = @constructor.childMetatemplates[key]
      # TODO(syu) refactor
      # This basically sets a defaultValue (so that we can get around the bug#1)
      # Root problem is we don't have a good "universal-default" value
      #   because _coerceToValidJsonInput throws errors
      defaultValue = if childMetatemplate?
                       Humon.contextualize(childMetatemplate.name)._initJsonDefaults(false)
                     else
                       null
      newChildNode = Humon.json2node defaultValue, metatemplate: childMetatemplate
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
  # @override
  _initJsonDefaults: (json) ->
    @_super(json)

  ##
  # @override
  _coerceToValidJsonInput: (json) ->
    console.warn "Coercing json #{JSON.stringify json} to #{@}"
    return {}
)
