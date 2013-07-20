window.HumonTypes =
  _types: {}
  _typeKeys: []

  defaultTemplateStrings:
    asString: (node) -> node.get('nodeVal') + ""
    asJson: (node) -> HumonTypes.contextualize(node).hnv2j(node.get 'nodeVal')
    iconClass: (node) -> HumonTypes.contextualize(node).iconClass

  defaultContext: (type) ->
    # templateName: "humon_node_#{type}"
    templateName: "humon_node_literal"
    iconClass: "icon-circle-blank"
    matchesAgainstJson: (json) ->
      typeof json == type
    hnv2j: (node) ->
      json = node
    j2hnv: (json) ->
      node = json
    _materializeTemplateStringsForNode: (node) ->
      # if the registered templateStrings is a function, lazy-evaluate it
      # with the node as the argument
      templateStrings = @templateStrings
      if typeof @templateStrings is "function"
        templateStrings = @templateStrings.call(@, node)
      # update templateStrings by merging it into the default template
      # strings
      templateStrings = $.extend {}, HumonTypes.defaultTemplateStrings, templateStrings
      # for templateString, lazy evaluate if it's a function
      ret = {}
      for own k, v of templateStrings
        ret[k] = if typeof v is "function"
                   v.call(@, node)
                 else
                   v
      ret

  register: (type, context) ->
    # TODO make warnings about malformed args
    defaultContext = HumonTypes.defaultContext(type)
    @_types[type] = $.extend {}, defaultContext, context

    # insert type at the beginning of _typeKeys
    @_typeKeys.splice 0, 0, type

  contextualize: (type) ->
    if type.constructor == Sysys.HumonNode
      type = type.get('nodeType')
    @_types[type] || Em.assert("Could not find type #{type}")

  # resolveType
  # param json json: the json that we want to know the type of
  # returns: a string, the name of the type
  #
  # Context: is called by HumonUtils.json2HumonNode in the literal node case (when
  # `json` is not a hash or a list. `resolveType`
  resolveType: (json) ->
    for type in @_typeKeys
      if HumonTypes._types[type].matchesAgainstJson json
        return type
    Em.assert "unrecognized type for json2humonNode: #{json}", false

HumonTypes.register "string"
HumonTypes.register "number"
HumonTypes.register "null",
  iconClass: "icon-ban-circle"
  matchesAgainstJson: (json) ->
    json == null
  templateStrings:
    asString: "!null"

HumonTypes.register "boolean"
