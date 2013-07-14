window.HumonTypes =
  _types: {}
  _typeKeys: []

  contextExample:
    name: "string"
    templateName: "humon_node_string"
    # Returns true if the json value could EVER resolve to this type
    # priorities are determined by the order in which types are registered
    # priorities are determined by the order in which types are registered
    typeInferers: ->
    matchAgainstJson: (json) ->
      typeof "json" == "string"

  register: (type, context) ->
    # TODO make warnings about malformed args
    defaultContext =
      templateName: "humon_node_#{type}"
      matchAgainstJson: (json) ->
        typeof json == type
      hnv2j: (node) ->
        json = node
      j2hnv: (json) ->
        node = json
      templateStrings: (node) ->
        nodeVal = node.get('nodeVal')
        ret =
          asString: nodeVal.toString()
          asJson: HumonTypes.contextualize(type).hnv2j(node.get 'nodeVal')
        ret

    @_types[type] = $.extend defaultContext, context
    @_typeKeys.splice 0, 0, type

  contextualize: (type) ->
    if type.constructor == Sysys.HumonNode
      type = type.get('nodeType')
    @_types[type] || Em.assert("Could not find type #{type}")

  resolveType: (json) ->
    for type in @_typeKeys
      if HumonTypes._types[type].matchAgainstJson json
        return type
    if Sysys.HumonUtils.isNumber json
      return "number"
    if Sysys.HumonUtils.isBoolean(json)
      return "boolean"
    if Sysys.HumonUtils.isNull(json)
      return "null"
    if Sysys.HumonUtils.isString(json)
      return "string"
    Em.assert "unrecognized type for json2humonNode: #{json}", false

HumonTypes.register "string"
HumonTypes.register "number"
HumonTypes.register "null",
  matchAgainstJson: (json) ->
    json == null
HumonTypes.register "boolean"
