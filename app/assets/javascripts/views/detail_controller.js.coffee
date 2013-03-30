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
    @activateNode blank, focus: true

  # commits the key changes
  # commits the val changes
  commitChanges: ->
    @commitKey()
    @commitVal()

  commitKey: ->
    rawString =  @get('activeHumonNodeView').$keyField().val()
    # rawString = @get('activeHumonNodeView').$('> span > .content-field.key-field')?.first()?.val()
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
          JSON.parse rawString
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
    nodeKey = ahn.get('nodeKey')
    nodeVal = ahn.get('nodeVal')

    # if there's a key and it's blank
    if nodeKey? && nodeKey == ''
      @focusKeyField()

    # if it's a collection
    if nodeKey? && ahn.get('isCollection')
      @focusKeyField()

    # if it's a
    if nodeKey? && nodeKey != ''
      @focusValField()

    if !nodeKey?
      @focusValField()

    if ahn.get('nodeParent.isList') and ahn.get('isCollection')
      @focusIdxField()

    if ahn.get('nodeParent.isHash') and ahn.get('isCollection')
      @focusKeyField()

    if ahn.get('isCollection') and not ahn.get('hasChildren')
      @focusProxyField()

  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$('> span > .content-field.key-field').first()
    $kf.focus()
    unless $kf.length
      $idxf = @get('activeHumonNodeView').$idxField()
      $idxf.focus()

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
  activateNode: (node, {focus} = {focus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusActiveNodeView()

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
    @activateNode(next, focus: true)

  insertChild: ->
    ahn = @get('activeHumonNode')
    Em.assert 'humon node should be a collection', ahn.get('isCollection')
    nextBlank = (Sysys.j2hn "")
    Em.run => ahn.insertAt 0, nextBlank
    @activateNode(nextBlank, focus: true)

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
