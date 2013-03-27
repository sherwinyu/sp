Sysys.HumonNode = Ember.Object.extend
  nodeKey: null
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  keyBinding: 'nodeKey'

  json: (->
    Sysys.HumonUtils.humonNode2json @
  ).property('nodeVal', 'nodeKey', 'nodeType')

  # make this more generic?
  nodeValChanged: (->
    @get('nodeParent')?.notifyPropertyChange 'nodeVal'
  ).observes 'nodeVal', 'nodeKey', 'nodeType'

  nodeIdx: ((key, val)->
    if arguments.length > 1
      return
    @get('nodeParent.nodeVal')?.indexOf @
  ).property('nodeParent.nodeVal.@each', 'nodeParent.nodeVal')

  hasKey: (->
    @get('nodeKey')?
  ).property 'nodeKey'

  isHash: (-> 
    @get('nodeType') == 'hash'
  ).property('nodeType')

  isList: (-> 
    @get('nodeType') == 'list'
  ).property('nodeType')

  isCollection: (->
    @get('isList') || @get('isHash')
  ).property 'nodeType'

  hasChildren: (->
    @get('isCollection') and @get('nodeVal').length
  ).property('isCollection', 'nodeVal')

  isLiteral: (-> 
    @get('nodeType') == 'literal'
  ).property('nodeType')

  getNode: (keyOrIndex) ->
    Em.assert("HumonNode must be a list or a hash to getNode(#{keyOrIndex})", @get('isHash') || @get('isList'))
    nodeVal = @get('nodeVal')
    childNode = 
      if @get('isHash')
        nodeVal.findProperty('nodeKey', keyOrIndex)
      else if @get('isList')
        nodeVal.get keyOrIndex
    return childNode

  childrenAsList: (->
    []
  ).property('nodeVal', 'nodeType')

  nextNode:  ->
    if @get('hasChildren')
      return @get('nodeVal')[0]
    curNode = @
    isLastChild = (child) ->
      child.get('nodeParent.nodeVal')[ child.get('nodeParent.nodeVal').length - 1 ] == child

    while curNode.get('nodeParent') and isLastChild(curNode)
      curNode = curNode.get('nodeParent')
    i = curNode.get('nodeParent.nodeVal')?.indexOf(curNode) + 1
    return curNode.get('nodeParent.nodeVal')[i] if i
    null

  prevNode: ->
    # there can be no previous node if there is no parent (and therefore no siblings)
    unless @get('nodeParent')
      return null
    # if this is the first child, the previous node is just the parent
    if @get('nodeParent.nodeVal')[0] == @ 
      return @get('nodeParent')
    # otherwise, start at the previous sibling
    curNode = @get('nodeParent.nodeVal')[ @get('nodeParent.nodeVal').indexOf(@) - 1 ]
    # while the sibling we're exploring has children, follow the last child
    while curNode.get('hasChildren')
      curNode = curNode.get('nodeVal')[ curNode.get('nodeVal').length - 1 ]
    curNode

  #TODO(syu): test me
  convertToHash: ->
    Em.assert('HumonNode must be a collection to convert to hash', @get('isCollection'))
    return if @get('isHash')
    @set('nodeType', 'hash')
    for node, idx in @get('nodeVal')
      # set the key unless nodeKey 1) exists 2) is nonempty
      node.set 'nodeKey', "#{idx}" unless node.get('nodeKey')

  #TODO(syu): test me
  convertToList: ->
    Em.assert('HumonNode must be a collection to convert to hash', @get('isCollection'))
    return if @get('isList')
    @set 'nodeType', 'list'

  unknownProperty: (key) ->
    return @getNode(key)?.get 'json'

  replaceWithJson: (json)->
    humonNode = Sysys.j2hn json
    @replaceWithHumonNode humonNode

  replaceWithHumonNode: (humonNode)->
    @set('nodeVal', humonNode.get 'nodeVal')
    @set('nodeType', humonNode.get 'nodeType')
    if @get 'isHash'
      for child in @get('nodeVal')
        child.set('nodeParent', @)
    if @get 'isList'
      for child in @get('nodeVal')
        child.set 'nodeParent', @

  replaceAt: (idx, amt, nodes...) ->
    @replaceAtWithArray(idx, amt, nodes)

  replaceAtWithArray: (idx, amt, nodes) ->
    Em.assert("HumonNode must be a list or a hash to replaceAt(#{idx},#{amt},#{nodes})", @get('isCollection'))
    list = @get 'nodeVal'
    if nodes?
      for node in nodes
        node.set('nodeParent', @)
    list.replace idx, amt, nodes

  insertAt: (idx, nodes...) ->
    Em.assert("HumonNode must be a list or a hash to insertAt(#{idx},#{nodes})", @get('isCollection'))
    @replaceAtWithArray(idx, 0, nodes)

  deleteAt: (idx, amt) ->
    Em.assert("HumonNode must be a list or a hash to deleteAt(#{idx},#{amt})", @get('isCollection'))
    @replaceAtWithArray(idx, amt)

  deleteChild: (node)->
    Em.assert('Child argument must be a child of this node for deleteChild', node.get('nodeParent') == @)
    idx = node.get('nodeIdx')
    @deleteAt(idx, 1)
    node.set 'nodeParent', null

  # different from set nodeKey directly because it will coerce the parent to a hash
  editKey: (newKey) ->
    parent = @get('nodeParent')
    parent.set 'nodeType', 'hash'
    @set 'nodeKey', newKey
