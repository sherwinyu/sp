window.HumonTypes =
  _types: {}
  _typeKeys: []

  defaultTemplateStrings:
    asString: (node) -> node.get('nodeVal') + ""
    asJson: (node) -> HumonTypes.contextualize(node).hnv2j(node.get 'nodeVal')
    iconClass: (node) -> HumonTypes.contextualize(node).iconClass

  # called by `HumonTypes.register` to generate a default context
  # (evaluating against the type name) for the type.
  #
  # param type string -- the string representation of the name of the type
  # returns a js object -- represents context for this type
  #
  # context
  #   the returned context object can then be overriden in `register` by additional
  #   user-specified context
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

    # _materializeTemplateStringsForNode
    # param node node -- the node against which to evaluate the template strings
    # returns
    _materializeTemplateStringsForNode: (node) ->
      # if the registered templateStrings is a function, lazy-evaluate it
      # with the node as the argument
      templateStrings = @templateStrings
      if typeof @templateStrings is "function"
        templateStrings = @templateStrings.call(@, node)
      # update templateStrings by merging it into the default template
      # strings

      # merge templateStrings into default templateStrings into newObject
      templateStrings = $.extend {}, HumonTypes.defaultTemplateStrings, templateStrings

      # for each template string, lazy evalute and inject
      # it into the return object
      ret = {}
      for own k, v of templateStrings
        ret[k] = if typeof v is "function"
                   v.call(@, node)
                 else
                   v
      ret
  ## END `defaultContext`

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

HumonTypes.register "string",
  iconClass: "icon-quote-left"

HumonTypes.register "number",
  iconClass: "icon-superscript"

HumonTypes.register "null",
  iconClass: "icon-ban-circle"
  matchesAgainstJson: (json) ->
    json == null
  templateStrings:
    asString: "null"

HumonTypes.register "boolean",
  iconClass: "icon-check"

  matchesAgainstJson: (json) ->
    json in ["true", "false", true, false]

  j2hnv: (json) ->
    if json in ["true", true]
      true
    else if json in ["false", false]
      false
    else
      Em.assert "Invalid json for boolean inference"
