window.HumonUtils =
  ##
  # @param [metatemplate] metatemplate
  # @return [instance of Humon.HumonValue]
  # If metatemplate.typeName is specified, then look it up.
  _typeClassFromMeta: (metatemplate) ->
    # If metatemplate has an explicitly defined type class, just use that
    if metatemplate.type? and Humon.HumonValue.detect(metatemplate.type)
      return metatemplate.type

    # If the metatemplate is already typified under Humon.#{metatemplate.name}"
    # then just return the type classs
    if Humon.HumonValue.detect(Humon[metatemplate.name].prototype)
      # TODO(syu): assert that the TypeClass's metatemplate is equivalent to the passed in
      # `metatemplate`
      return Humon[metatemplate.name]

    Em.assert("Metatemplate must have a name", metatemplate.name?)
    @_typifyClassFromMeta(metatemplate)

  ##
  # Turns the metatemplate into a a new type, with a name
  _typifyClassFromMeta: (metatemplate) ->
    throw new Error "not implemented yet"

  ##
  # @param [JSON] json json representation to test
  # @return [Humon.HumonValue subclass] a class representing a subclass of `HumonValue`
  # Called by json2node when no context is available
  _resolveTypeClassFromJson: (json) ->
    for type in Humon._types
      typeClass = Humon.contextualize(type)
      if typeClass.matchesJson(json)
        return typeClass
    throw new Error "Unresolved type for payload #{JSON.stringify json}!"

  ##
  # @param [JSON] json the json payload to convert to HumonValue wrapped in a Humon.Node
  # @param context -- optional
  #   - nodeParent: the node that will be the parent context of the current json payload
  #   - key: a string, the name of the attribute of the `nodeParent` that the payload corresponds to
  #     TODO(syu): this key is used to determine the `type`, (via a lookup against
  #     the parent's Humon template), but for now, we are passing the `type` explicitly
  #   - type: a subclass of Humon.HumonValue, indicating the type that `json` should resolve to
  #     TODO(syu): later, allow this to resolve to multiple types
  # @return [Humon.Node] the returned node wraps a Humon.Value
  # The returned HumonNode will have its nodeParent set to `context.nodeParent`
  # If `type` is provided, the correspoinding HumonTypeClass's `j2hnv` is used to
  # generate the `nodeVal` from `json`
  # If `type` is not provided, `_resolveTypeClassFromJson` is used to determine the type class.
  # The node's `nodeType` is set accordingly (as a string).
  json2node: (json, context={}) ->

    node = Humon.Node.create
      nodeParent: context.nodeParent

    typeClass =
      if context.type?
        context.type
      else if context.metatemplate
        HumonUtils._typeClassFromMeta(context.metatemplate)
      else # Don't pass in context because this occurs when context isn't provided!
        HumonUtils._resolveTypeClassFromJson json

    nodeVal = typeClass.j2hnv json, node: node
    node.set 'nodeVal', nodeVal
    node.set 'nodeType', nodeVal.name()

    return node

  node2json: (node)->
    node.get('nodeVal').toJson()

Humon.n2j = HumonUtils.node2json
Humon.j2n = HumonUtils.json2node
