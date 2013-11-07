window.HumonUtils =
  # @param json
  # @param context -- optional
  # Context:
  #   nodeParent: the node that will be the parent context of the current json payload
  #   key: a string, the name of the attribute of the `node` that the payload corresponds to
  #   type: a subclass of Humon.HumonValue, indicating the type that `json` should resolve to
  #     # TODO(syu): later, allow this to resolve to multiple types
  json2node: (json, context={}) ->

    node = Sysys.HumonNode.create
      nodeParent: context.nodeParent
    context.node = node

    if context.type?
      typeClass = context.type
      nodeVal = typeClass.j2hnv json, context
      node.set 'nodeVal', nodeVal
      node.set 'nodeType', typeClass.name
    else
      throw new Error "Couldn't determine a type for #{JSON.stringify json}"
    return node

  # Called when no context is available
  # @return a subclass of HumonValue
  resolveTypeFromJson: (json) ->
    for type in Humon._types
      typeClass = Humon[type]
      if typeClass.matchesJson(json)
        return typeClass
    throw "Unresolved type for payload #{JSON.stringify json}!"

  node2json: (node)->
    node.get('nodeVal').toJson()

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
      #TODO(syu): add back the assert
        Em.assert "node is a literal", node.get('isLiteral')
        ret = HumonTypes.contextualize(type).hnv2j(nodeVal)
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
    else if Sysys.HumonUtils.isList(json) && json.length == 2
      # FORCE A HUmonNodeCouple
      nodeType = 'couple'
      node.set 'nodeType', nodeType
      node.set 'nodeVal', HumonTypes.contextualize(nodeType).j2hnv( json, node: node)

    else if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      children = Em.A()
      for val in json
        child = Sysys.HumonUtils.json2humonNode val, node
        children.pushObject child
      node.set 'nodeVal', children
    else # json corresponds to a literal
      nodeType = HumonTypes.resolveType(json)
      node.set 'nodeType', nodeType
      node.set 'nodeVal', HumonTypes.contextualize(nodeType).j2hnv json
    node



    ###
    if Sysys.HumonUtils.isHash json
      node.set('nodeType', 'hash')
      children = Em.A()
      for own key, val of json
        child = Sysys.HumonUtils.json2humonNode val, node
        child.set 'nodeKey', key
        children.pushObject child
      node.set 'nodeVal', children
    else if Sysys.HumonUtils.isList(json) && json.length == 2
      # FORCE A HUmonNodeCouple
      nodeType = 'couple'
      node.set 'nodeType', nodeType
      node.set 'nodeVal', HumonTypes.contextualize(nodeType).j2hnv( json, node: node)

    else if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      children = Em.A()
      for val in json
        child = Sysys.HumonUtils.json2humonNode val, node
        children.pushObject child
      node.set 'nodeVal', children
    else # json corresponds to a literal
      nodeType = HumonTypes.resolveType(json)
      node.set 'nodeType', nodeType
      node.set 'nodeVal', HumonTypes.contextualize(nodeType).j2hnv json
    node
    ###


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
  isLiteral: (val) ->
     val == null || typeof val isnt 'object'

Sysys.j2hn = Sysys.HumonUtils.json2humonNode
Sysys.hn2j = Sysys.HumonUtils.humonNode2json
