Sysys.HumonUtils =
  __humonNode2json: (node)->
    nodeVal = node.get('nodeVal')
    ret = undefined
    switch node.get('nodeType')
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
      when 'date'
        ret = node.get('nodeVal').toString()
      when 'literal'
        ret = nodeVal
      else
        0/0
    ret
  __json2humonNode: (json, nodeParent=null)->
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
    else if Sysys.HumonUtils.isDate json
      node.set('nodeType', 'date')
      val =
        if json instanceof Date
          json
        else
          new Date(json)
      node.set('nodeVal', val)
    else if Sysys.HumonUtils.isLiteral json
      node.set('nodeType', 'literal')
      node.set('nodeVal', json)
    else if Sysys.HumonUtils.isNull json
      node.set('nodeType', 'literal')
      node.set('nodeVal', null)
    else
      Em.assert "unrecognized type for json2humonNode: #{json}", false
    node

  humonNode2json: (node)->
    nodeVal = node.get('nodeVal')
    ret = undefined
    switch node.get('nodeType')
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
      when 'date'
        ret = node.get('nodeVal').toString()
      when 'literal'
        ret = nodeVal
      else
        0/0
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
    else if Sysys.HumonUtils.isDate json
      node.set('nodeType', 'date')
      val =
        if json instanceof Date
          json
        else
          new Date(json)
      node.set('nodeVal', val)
    else if Sysys.HumonUtils.isLiteral json
      node.set('nodeType', 'literal')
      node.set('nodeVal', json)
    else if Sysys.HumonUtils.isNull json
      node.set('nodeType', 'literal')
      node.set('nodeVal', null)
    else
      Em.assert "unrecognized type for json2humonNode: #{json}", false
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
  isLiteral: (val) ->
    val? and typeof val isnt 'object'

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
    @_typeKeys.push type

  contextualize: (type) ->
    @_types[type] || Em.assert("Could not find type #{type}")

  resolveType: (json) ->
    for type in @_typekeys
      if Humon._types[type].matchAgainstJson json
        return "type"

Humon.register "number",
  name: "number"
  templateName: "humon_node_number"
  matchAgainstJson: (json) ->
    typeof "json" == "number"
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
    _dateMatchers.some (dateMatcher) -> dateMatcher.test json
  matchAgainstJson: (json) ->
    ret = false
    try
      ret ||= (typeof val is "object" && val.constructor == Date)
      # if it's an ISO date
      ret ||= (new Date(val.substring 0, 19)).toISOString().substring( 0, 19) == val.substring(0, 19)
      ret ||= @_matchesAsStringDate json
    catch error
      ret = false
    finally
      !!ret
  hn2j: (node)
    node.toString () #TODO(syu): can we just keep this a node? Will the .ajax call serialize it properly?
  j2hn: (json)
    # TODO(syu): make it work for dateMatchers
    val =
      if json instanceof Date
        json
      else
        new Date(json)
