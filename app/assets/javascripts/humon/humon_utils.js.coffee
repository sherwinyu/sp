window.HumonUtils =
  # @param json.
  # @param context -- optional
  #   - nodeParent: the node that will be the parent context of the current json payload
  #   - key: a string, the name of the attribute of the `nodeParent` that the payload corresponds to
  #     TODO(syu): this key is used to determine the `type`, (via a lookup against
  #     the parent's Humon template), but for now, we are passing the `type` explicitly
  #   - type: a subclass of Humon.HumonValue, indicating the type that `json` should resolve to
  #     TODO(syu): later, allow this to resolve to multiple types
  # @returns HumonNode
  # The returned HumonNode will have its nodeParent set to `context.nodeParent`
  # If `type` is provided, the correspoinding HumonTypeClass's `j2hnv` is used to
  # generate the `nodeVal` from `json`
  # If `type` is not provided, `resolveTypeFromJson` is used to determine the type class.
  # The node's `nodeType` is set accordingly (as a string).
  json2node: (json, context={}) ->

    node = Humon.Node.create
      nodeParent: context.nodeParent

    if context.type?
      # If provided, look up the typeClass from the `context` arg.
      typeClass = context.type
    else
      # Don't pass in context because this occurs when context isn't provided!
      typeClass = HumonUtils.resolveTypeFromJson json
    nodeVal = typeClass.j2hnv json, node: node
    node.set 'nodeVal', nodeVal
    node.set 'nodeType', nodeVal.name()

    return node

  # @param json
  # @return a subclass of `HumonValue`
  # Called when no context is available
  resolveTypeFromJson: (json) ->
    for type in Humon._types
      typeClass = Humon[type]
      if typeClass.matchesJson(json)
        return typeClass
    throw new Error "Unresolved type for payload #{JSON.stringify json}!"

  node2json: (node)->
    node.get('nodeVal').toJson()

Humon.n2j = HumonUtils.node2json
Humon.j2n = HumonUtils.json2node
