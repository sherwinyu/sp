Sysys.HumonNode = Ember.Object.extend
  nodeKey: null
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  keyBinding: 'nodeKey'

  json: (->
    Sysys.HumonUtils.humonNode2json @
  ).property('nodeVal', 'nodeKey')

  # make this more generic?
  nodeValChanged: (->
    @get('nodeParent')?.notifyPropertyChange 'nodeVal'
  ).observes 'nodeVal'

  hasKey: (->
    !!@get 'nodeKey'
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
    Em.assert('HumonNode must be a list or a hash', @get('isHash') || @get('isList'))
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
    console.log 'zup'
    unless @get('nodeParent')
      return null
    if @get('nodeParent.nodeVal')[0] == @ 
      return @get('nodeParent')
    curNode = @get('nodeParent.nodeVal')[ @get('nodeParent.nodeVal').indexOf(@) - 1 ] # start at prev sibling
    while curNode.get('hasChildren')
      curNode = curNode.get('nodeVal')[ curNode.get('nodeVal').length - 1 ]
    curNode

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

  replaceAt: (idx, amt, objects) ->
    Em.assert('HumonNode must be a list or a hash', @get('isHash') || @get('isList'))
    list = @get 'nodeVal'
    list.replace idx, amt, objects

  # different from set nodeKey directly because it will coerce the parent to a hash
  editKey: (newKey) ->
    parent = @get('nodeParent')
    parent.set 'nodeType', 'hash'
    @set 'nodeKey', newKey
