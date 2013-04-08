# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  anims: {}
  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNode: null

  ######################################
  ##  Committing (keys and values)
  #####################################

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
    json =
      try 
        humon.parse rawString
      catch error
        try
          JSON.parse rawString
        catch error
          ""
    if rawString?
      Ember.run =>
        @get('activeHumonNode').replaceWithJson json

  ######################################
  ##  Manipulating focus
  #####################################
  #
  smartFocus: ->
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

  focusLabelField : ->
    $lf = @get('activeHumonNodeView').$labelField().focus()
  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$keyField().focus()
  focusValField: ->
    $vf = @get('activeHumonNodeView').$valField().focus()
  focusIdxField: ->
    $if = @get('activeHumonNodeView').$idxField().focus()
  focusProxyField: ->
    $pf = @get('activeHumonNodeView').$proxyField().focus()


######################################
##  Setting Active Node
######################################

  activateNode: (node, {focus, unfocus} = {focus: false, unfocus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @smartFocus()

  nextNode: ->
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode, focus: true 

##################################
## Manipulating humon node tree
##################################

  # Changes context to a hash
  # If activeNode is a literal and activeNode's parent is a list, convert the parent to a hash
  # If activeNode is a list, convert it to a hash
  forceHash: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isList')
      ahn.convertToHash()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isList')
      ahn.get('nodeParent')?.convertToHash()
    @smartFocus()

  # Changes context to a hash
  # If activeNode is a literal and activeNode's parent is a list, convert the parent to a hash
  # If activeNode is a list, convert it to a hash
  forceList: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isHash')
      ahn.convertToList()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isHash')
      ahn.get('nodeParent')?.convertToList()
    @smartFocus()

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
    @smartFocus()

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
    @smartFocus()

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
    @smartFocus()

  indent: ->
    ahn = @get 'activeHumonNode'
    parent = ahn.get('nodeParent')
    prevSib = parent?.get('nodeVal')[ ahn.get('nodeIdx') - 1]
    return unless prevSib && prevSib.get('isCollection')
    Ember.run =>
      parent.deleteChild ahn
      prevSib.insertAt prevSib.get('nodeVal.length'), ahn
    @smartFocus()
