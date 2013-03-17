Sysys.HumonNode = Ember.Object.extend
  nodeKey: null
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  json: (->
    Sysys.HumonUtils.humonNode2json @
  ).property('nodeVal', 'nodeKey')

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

  isLiteral: (-> 
    @get('nodeType') == 'literal'
  ).property('nodeType')

  isFlatCollection: (->
    false
    if @get('isLiteral')
      return true
    else
      singlechildren = @get('isHash') and @get('nodeVal.length') == 1
      return singlechildren and @get('nodeVal.0.val.isFlatCollection')
  ).property('nodeVal.@each', 'nodeType')

  getNode: (keyOrIndex) ->
    Em.assert('HumonNode must be a list or a hash', @get('isHash') || @get('isList'))
    nodeVal = @get('nodeVal')
    childNode = 
      if @get('isHash')
        nodeVal.findProperty('key', keyOrIndex)?.val
      else if @get('isList')
        nodeVal.get keyOrIndex
    return childNode

  unknownProperty: (key) ->
    return @getNode(key)?.get 'json'

  replaceWithJson: (json)->
    humonNode = Sysys.j2hn json
    @replaceWithHumonNode humonNode

  replaceWithHumonNode: (humonNode)->
    @set('nodeVal', humonNode.get 'nodeVal')
    @set('nodeType', humonNode.get 'nodeType')
    if @get 'isHash'
      for kvp in @get('nodeVal')
        kvp.val.set('nodeParent', @)
    if @get 'isList'
      for node in @get('nodeVal')
        node.set 'nodeParent', @

  replaceAt: (idx, amt, objects) ->
    Em.assert('HumonNode must be a list or a hash', @get('isHash') || @get('isList'))
    list = @get 'nodeVal'
    list.replace idx, amt, objects

  editKey: (newKey) ->
    parent = @get('nodeParent')
    Em.assert 'Parent must be a hash', parent?.get('isHash')
    kvp =  parent.get('nodeVal').findProperty('val', @)
    kvp.set 'key', newKey
