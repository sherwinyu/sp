Sysys.HumonNode = Ember.Object.extend
  nodeVal: null
  nodeType: null
  nodeParent: null
  json: (->
    Sysys.HumonUtils.humonNode2json @
    # val = @get('nodeVal')
    # 
    # if @get('isLiteral')
    # return val
    # else 5
  ).property('nodeVal')

  isHash: (-> 
    @get('nodeType') == 'hash'
  ).property('nodeType')

  isList: (-> 
    @get('nodeType') == 'list'
  ).property('nodeType')

  isLiteral: (-> 
    @get('nodeType') == 'literal'
  ).property('nodeType')

  unknownProperty: (key) ->
    console.log 'key:', key
    [idx, remaining...] = key.split '.'
    nodeVal = @get('nodeVal')
    childNode = 
      if @get('isHash')
        nodeVal.findProperty('key', idx).val
      else if @get('isList')
        nodeVal.get idx
        # if remaining.length
        # childNode.get remaining.join '.'
        # else 
    childNode.get 'json'

  replaceAt: (idx, amt, objects) ->
    debugger
    Em.assert('HumonNode must be a list or an array', @get('isHash') || @get('isList'))
    list = @get 'nodeVal'
    list.replace idx, amt, objects


