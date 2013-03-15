Sysys.HumonUtils = 
  humonNode2json: (node)->
    val = node.get('nodeVal')
    ret = undefined
    if node.get('isList')
      ret = []
      for v in val
        ret.pushObject Sysys.HumonUtils.humonNode2json v
    if node.get('isHash')
      ret = {}
      for kvp in val
        ret[kvp.key] = Sysys.HumonUtils.humonNode2json kvp.val
    if node.get('isLiteral')
      ret = val
    ret

  json2humonNode: (json, nodeParent=null)->
    node = Sysys.HumonNode.create
      nodeParent: nodeParent

    if Sysys.HumonUtils.isHash json
      node.set('nodeType', 'hash')
      kvps = Em.A()
      for own k, v of json
        kvp = Ember.Object.create
          key: k
          val: Sysys.HumonUtils.json2humonNode v, node
        kvps.pushObject kvp
      node.set('nodeVal', kvps)

    if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      arr = Em.A()
      for ele in json
        arr.pushObject Sysys.HumonUtils.json2humonNode ele, node
      node.set 'nodeVal', arr

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
