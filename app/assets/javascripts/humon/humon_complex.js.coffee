#= require_self
#= require ./humon_sleep

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
  #
  # The metatemplate corresponding to THIS PATH should be @_metatemplate
  # because THIS is already an instance of a Humon.*
  #
  # `childMetatemplates` is an available variable that contains metatemplates
  # for all childNodes.
  j2hnv: (json, context) ->
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
