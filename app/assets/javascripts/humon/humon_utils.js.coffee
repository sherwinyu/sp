Sysys.HumonUtils = 
  humonNode2json: (node)->
    nodeVal = node.get('nodeVal')
    ret = undefined
    if node.get('isList')
      ret = []
      for child in nodeVal
        ret.pushObject Sysys.HumonUtils.humonNode2json child
    if node.get('isHash')
      ret = {}
      for child in nodeVal
        key = child.get('nodeKey')
        key ?= nodeVal.indexOf child
        ret[key] = Sysys.HumonUtils.humonNode2json child
    if node.get('isLiteral')
      ret = nodeVal
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

    if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      children = Em.A()
      for val in json
        child = Sysys.HumonUtils.json2humonNode val, node
        children.pushObject child
      node.set 'nodeVal', children

    if Sysys.HumonUtils.isLiteral json
      node.set('nodeType', 'literal')
      node.set('nodeVal', json)
    node
    
  isHash: (val) ->
    val? and (typeof val is 'object') and !(val instanceof Array)
  isList: (val) ->
    val? and typeof val is 'object' and val instanceof Array and typeof val.length is 'number'

  #TODO(syu): support date literals
  isLiteral: (val) ->
    val? and typeof val isnt 'object'

Sysys.j2hn = Sysys.HumonUtils.json2humonNode
Sysys.hn2j = Sysys.HumonUtils.humonNode2json
