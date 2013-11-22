## sleep example
Humon.Complex = Humon.Hash.extend(
  isComplex: true
  #  key: name, value: metatemplate

  # _requiredAttributes: null


  # requiredAttributes: (->
  #   for own k, v of @_requiredAttrs
  #     attributekey: k
  #     attributeVal: @get(k)
  # ).property()
)

Humon.Complex.reopenClass(
  childMetatemplates: {}

  _metatemplate:
    $include: Humon.Hash._metatemplate
    $required: []

  # @param context
  #  context.node: the Humon.Node object that will wrap this Humon.Value
  j2hnv: (json, context) ->
    # TODO(syu) context.metatemplate describes the value to be returned at THIS place.
    # This "generic" j2hnv (that more specified complex hashes can inherit from)
    # should set up appropriate subchild calls.
    # Appropriate: for child nodes, it inferes the appropriate metatemplate from `context.metatemplate` and then calls the appropriate Humon.*'s
    # TODO(syu): is this out of date?
    childNodes = []
    for own key, childVal of json
      childContext =
        nodeParent: context.node
        metatemplate: @childMetatemplates[key]
      childNode = HumonUtils.json2node(childVal, childContext)
      childNode.set 'nodeKey', key
      childNodes.pushObject childNode
    @create _value: childNodes, node: context.node

)
