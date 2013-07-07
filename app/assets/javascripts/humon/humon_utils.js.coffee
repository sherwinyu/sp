Sysys.HumonUtils =

  humonNode2json: (node)->
    nodeVal = node.get('nodeVal')
    ret = undefined
    type = node.get('nodeType')
    switch type
      when 'list'
        ret = []
        for child in nodeVal
          ret.pushObject Sysys.HumonUtils.humonNode2json child
      when 'hash'
        ret = {}
        for child in nodeVal
          key = child.get('nodeKey')
          key ?= nodeVal.indexOf child
          ret[key] = Sysys.HumonUtils.humonNode2json child
      else
        Em.assert "node is a literal", node.get('isLiteral')
        ret = Humon.contextualize(type).hn2j(nodeVal)
      #TODO(syu): handle error case
    ret

  json2humonNode: (json, nodeParent=null)->
    node = Sysys.HumonNode.create
      nodeParent: nodeParent

    if Sysys.HumonUtils.isHash json
      node.set('nodeType', 'hash')
      children = Em.A()
      for own key, val of json
        child = Sysys.HumonUtils.json2humonNode val, node
        child.set 'nodeKey', key
        children.pushObject child
      node.set 'nodeVal', children
    else if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      children = Em.A()
      for val in json
        child = Sysys.HumonUtils.json2humonNode val, node
        children.pushObject child
      node.set 'nodeVal', children
    else # json corresponds to a literal
      nodeType = Humon.resolveType(json)
      node.set 'nodeType', nodeType
      node.set 'nodeVal', Humon.contextualize(nodeType).j2hn json
    node

  isHash: (val) ->
    val? and (typeof val is 'object') and !(val instanceof Array) and val.constructor == Object
  isList: (val) ->
    val? and typeof val is 'object' and val instanceof Array and typeof val.length is 'number'
  isNull: (val) ->
    val == null
  isBoolean: (val) ->
    typeof val is "boolean"
  isString: (val) ->
    typeof val is "string"
  isNumber: (val) ->
    typeof val is "number"
  isDate: (val) ->
    ret = false
    try
      ret ||= (typeof val is "object" && val.constructor == Date)
      # if it's an ISO date
      ret ||= (new Date(val.substring 0, 19)).toISOString().substring( 0, 19) == val.substring(0, 19)
    catch error
      ret = false
    finally
      !!ret

  #TODO(syu): support date literals
  # Definitely broke -- null is a literal
  isLiteral: (val) ->
     val == null || typeof val isnt 'object'

Sysys.j2hn = Sysys.HumonUtils.json2humonNode
Sysys.hn2j = Sysys.HumonUtils.humonNode2json

window.Humon =
  _types: {}
  _typeKeys: []

  contextExample:
    name: "string"
    templateName: "humon_node_string"
    # Returns true if the json value could EVER resolve to this type
    # priorities are determined by the order in which types are registered
    # priorities are determined by the order in which types are registered
    matchAgainstJson: (json) ->
      typeof "json" == "string"

  register: (type, context) ->
    # TODO make warnings about malformed args
    @_types[type] = context
    @_typeKeys.splice 0, 0, type

  contextualize: (type) ->
    if type.constructor == Sysys.HumonNode
      type = type.get('nodeType')
    @_types[type] || Em.assert("Could not find type #{type}")

  resolveType: (json) ->
    for type in @_typeKeys
      if Humon._types[type].matchAgainstJson json
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

Humon.register "number",
  name: "number"
  templateName: "humon_node_number"
  matchAgainstJson: (json) ->
    typeof json == "number"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

Humon.register "null",
  name: "null"
  templateName: "humon_node_null"
  matchAgainstJson: (json) ->
    json == null
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

Humon.register "boolean",
  name: "boolean"
  templateName: "humon_node_boolean"
  matchAgainstJson: (json) ->
    typeof json == "boolean"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

Humon.register "string",
  name: "string"
  templateName: "humon_node_string"
  matchAgainstJson: (json) ->
    typeof json == "string"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

Humon.register "date",
  name: "date"
  templateName: "humon_node_date"
  _dateMatchers: [
    /^now$/,
    /^tomorrow$/,
    /^tmrw$/,
  ]
  _matchesAsStringDate: (json) ->
    return false if json.constructor != String
    @_dateMatchers.some (dateMatcher) -> dateMatcher.test json
  matchAgainstJson: (json) ->
    ret = false
    try
      ret ||= (typeof json is "object" && json.constructor == Date)
      ret ||= @_matchesAsStringDate json

      # if it's an ISO date
      ret ||= (new Date(json.substring 0, 19)).toISOString().substring( 0, 19) == json.substring(0, 19)
    catch error
      console.log error.toString()
      ret = false
    finally
      !!ret
  hn2j: (node) ->
    node.toString() #TODO(syu): can we just keep this a node? Will the .ajax call serialize it properly?
  j2hn: (json) ->
    # TODO(syu): make it work for dateMatchers
    val =
      if json instanceof Date
        json
      else
        new Date(json)
