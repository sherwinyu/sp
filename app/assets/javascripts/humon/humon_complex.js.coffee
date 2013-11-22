## sleep example
Humon.Complex = Humon.Hash.extend(
  isComplex: true

  _requiredAttributes: null

  requiredAttributes: (->
    for own k, v of @_requiredAttrs
      attributekey: k
      attributeVal: @get(k)
  ).property()

  required:
  startedAtBinding: 'children.0'
  endedAtBinding: 'children.1'
  detailsBinding: 'children.2'
)

Humon.Sleep.reopenClass(
  _metatemplate:
    $typeName: 'sleep'
    $include: Complex._metatemplate
    $required: ["wokeup_at", "out_of_bed_at"]
    wokeup_at:
      $type: Humon.DateTime
      $display_as: "HH:MM"
    energy_at_wakeup:
      $type: "1to10answer"

  _metatemplate:
    $typeName: 'sleep'
    $include: Complex._metatemplate
    $required: ["wokeup_at", "out_of_bed_at"]
    wokeup_at:
      $type: Humon.DateTime
      $display_as: "HH:MM"
    energy_at_wakeup:
      $type: "1to10answer"

  _requiredAttributes:
    "startedAt": Humon.Time.metaTemplate
    "endedAt": Humon.Time.metaTemplate
    "details": Humon.MetaTemplate.create( ... )
)

Humon.Complex.reopenClass(
  _metatemplate:
    $include: Humon.Hash._metatemplate
    $required: []

  j2hnv: (json, context) ->
    # TODO(syu) context.metatemplate describes the value to be returned at THIS place.
    # This "generic" j2hnv (that more specified complex hashes can inherit from)
    # should set up appropriate subchild calls.
    # Appropriate: for child nodes, it inferes the appropriate metatemplate from `context.metatemplate` and then calls the appropriate Humon.*'s
    # j2nv
    childNode = HumonUtils.json2node(childVal,

    childNodes = []
    for own key, childVal of json

      # TODO(syuy): NEXT LINE should be metatemplate aware.
      childNode = HumonUtils.json2node(childVal, nodeParent: context)
      childNode.set 'nodeKey', key
      childNodes.pushObject childNode
    Humon.Hash.create _value: childNodes, node: context.node

)
