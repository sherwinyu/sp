# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  anims: {}
  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNode: null

  commitAndContinue: ->
    ahn = @get 'activeHumonNode'
    rawString =  @get('activeHumonNodeView').$valField().val() || '{}'
    @commitKey()
    @commitVal(rawString)
    Ember.run.sync()
    parent = ahn.get 'nodeParent'
    idx = ahn.get('nodeIdx') + 1
    if ahn.get 'isCollection'
      parent = ahn
      idx = ahn.get('nodeVal').length
    blank = (Sysys.j2hn "")
    Ember.run =>
      parent.replaceAt(idx, 0, blank)
    @activateNode blank, focus: true, unfocus: false

  # commits the key changes
  # commits the val changes
  commitChanges: ->
    @commitKey()
    @commit

  commit: ->
    rawString =  @get('activeHumonNodeView').$valField().val()
    @commitVal rawString



  commitKey: ->
    rawString =  @get('activeHumonNodeView').$keyField().val()
    if rawString?
      # TODO(syu): validate whether rawString can be a key
      @set('activeHumonNode.nodeKey', rawString)
    # TODO(syu): refresh key field

  # precondition: activeNode is a literal
  # params: rawString -- the rawString to parse and replace ahn with
  # calls replaceWithJson on activeNode
  commitVal: (rawString) ->
    return unless @get('activeHumonNode.isLiteral')
    Em.assert 'activeHumonNode needs to be a literal to commitChanges', @get('activeHumonNode.isLiteral')
    # rawString =  @get('activeHumonNodeView').$valField().val()
    if rawString?
      json =
        if rawString.length == 0
          {}
        else
          humon.parse rawString
      Ember.run =>
        @get('activeHumonNode').replaceWithJson json
    # TODO(syu): refresh val field

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    ahnv = @get('activeHumonNodeView')
    # ahnv.cancelChanges
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('> span > .content-field.val-field').first().val rawString

  focusActiveNodeView: ->
    Ember.run.sync()
    ahn = @get('activeHumonNode')
    ahnv = @get('activeHumonNodeView')
    context = ahn.get('nodeParent.nodeType')
    nodeKey = ahn.get('nodeKey')
    nodeVal = ahn.get('nodeVal')

    if context == 'hash' 
      if nodeKey.length == 0
        @focusKeyField()
      else
        @focusValField()
    else if context == 'list'
      if ahn.get 'hasChildren'
        @focusLabelField()
      else
        @focusValField()
    if ahn.get('isCollection')
      if not ahn.get('hasChildren')
        @focusProxyField()
      else
        @focusLabelField()

      ###
    # if it's a hash with an empty key"
    if context == 'hash' && nodeKey.length == 0
      @focusKeyField()

    # if it's a hash with children
    if context == 'hash' && ahn.get('isCollection') && ahn.get('hasChildren')
      @focusKeyField()

    # if it's a hash  without children
    if ahn.get('isCollection') and not ahn.get('hasChildren')
      @focusProxyField()

    # if it's a hash with an non empty key"
    if context == 'hash' && nodeKey.length
      @focusValField()


      # if nodeKey? && nodeKey != ''
      # @focusValField()
      # ###

  focusLabelField : ->
    $lf = @get('activeHumonNodeView').$labelField().focus()

  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$keyField()
    $kf.focus()

  focusValField: ->
    $vf = @get('activeHumonNodeView').$valField()
    $vf.focus()

  focusIdxField: ->
    $if = @get('activeHumonNodeView').$idxField()
    $if.focus()

  focusProxyField: ->
    $pf = @get('activeHumonNodeView').$proxyField()
    $pf.focus()

  # sets activeHumonNode to node if node exists
  activateNode: (node, {focus, unfocus} = {focus: false, unfocus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusActiveNodeView()
      if unfocus
        @commit()
        @commitKey()

  nextNode: ->
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode, focus: true 

  #TODO(syu): test me
  forceHash: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isList')
      ahn.convertToHash()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isList')
      ahn.get('nodeParent')?.convertToHash()

  #TODO(syu): test me
  forceList: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isHash')
      ahn.convertToList()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isHash')
      ahn.get('nodeParent')?.convertToList()

  # TODO(syu): test me
  bubbleUp: ->
    ahn = @get('activeHumonNode')
    dest = @get('activeHumonNode').prevNode()
    return unless dest?.get('nodeParent')
    @get('anims').destroy = 'disappear'
    @get('anims').insert  = 'slideUp'
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      dest.get('nodeParent').insertAt(dest.get('nodeIdx'), ahn)
    @focusActiveNodeView()

  bubbleDown: ->
    ahn = @get 'activeHumonNode'
    # Em.assert("can only bubble literals", ahn.get('isLiteral'))
    dest = @get('activeHumonNode').lastFlattenedChild().nextNode()
    return unless dest?.get('nodeParent')
    @get('anims').destroy = 'disappear'
    @get('anims').insert  = 'slideDown'
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      if dest.get('isLiteral')
        dest.get('nodeParent').insertAt(dest.get('nodeIdx') + 1, ahn)
      else
        dest.insertAt(0, ahn)
    @focusActiveNodeView()

  deleteActive: ->
    ahn = @get('activeHumonNode')
    @set('activeHumonNode', null)
    Ember.run.sync()
    next = ahn.prevNode() || ahn.nextNode()
    return unless next
    Ember.run => ahn.get('nodeParent')?.deleteChild ahn
    @activateNode(next, focus: true, unfocus: false)

  insertChild: ->
    ahn = @get('activeHumonNode')
    Em.assert 'humon node should be a collection', ahn.get('isCollection')
    nextBlank = (Sysys.j2hn "")
    Em.run => ahn.insertAt 0, nextBlank
    @activateNode(nextBlank, focus: true, unfocus: false)

  outdent: ->
    ahn = @get 'activeHumonNode'
    newSibling = ahn.get 'nodeParent'
    newParent = newSibling?.get 'nodeParent'
    return unless newParent and newSibling
    Ember.run =>
      newSibling.deleteChild ahn
      newParent.insertAt newSibling.get('nodeIdx') + 1, ahn
    @focusActiveNodeView()

  indent: ->
    ahn = @get 'activeHumonNode'
    parent = ahn.get('nodeParent')
    prevSib = parent?.get('nodeVal')[ ahn.get('nodeIdx') - 1]
    return unless prevSib && prevSib.get('isCollection')
    Ember.run =>
      parent.deleteChild ahn
      prevSib.insertAt prevSib.get('nodeVal.length'), ahn
    @focusActiveNodeView()
