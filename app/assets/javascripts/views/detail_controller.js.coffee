# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  anims: {}
  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNode: null

  commitAndContinue: ->
    ahn = @get('activeHumonNode')
    parent = ahn.get('nodeParent')
    idx = parent.get('nodeVal').indexOf(ahn) + 1
    nextBlank = (Sysys.j2hn "")
    unless ahn.get('nodeParent.isList')
      nextBlank.set 'nodeKey', ''
    Ember.run =>
      parent.replaceAt(idx, 0, nextBlank)
    @commitChanges()
    @activateNode nextBlank
    @focusActiveNodeView()

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
  # does jsonparsing of current activeHumonNodeView content-field.literal
  # calls replaceWithJson on activeNode
  commitVal: ->
    Em.assert 'activeHumonNode needs to be a literal to commitChanges', @get('activeHumonNode.isLiteral')
    rawString =  @get('activeHumonNodeView').$valField().val()
    # rawString = @get('activeHumonNodeView').$('> span > .content-field.val-field')?.first()?.val()
    if rawString?
      json = JSON.parse rawString
      Ember.run =>
        @get('activeHumonNode').replaceWithJson json
    # TODO(syu): refresh val field

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    ahnv = @get('activeHumonNodeView')
    # ahnv.cancelChanges
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('> span > .content-field.val-field').first().val rawString
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

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
      debugger
      ahn.get('nodeParent').deleteChild ahn
      dest.get('nodeParent').insertAt(dest.get('nodeIdx'), ahn)
    @focusActiveNodeView()

  bubbleDown: ->
    ahn = @get 'activeHumonNode'
    Em.assert("can only bubble literals", ahn.get('isLiteral'))
    dest = @get('activeHumonNode').nextNode()
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
    next = ahn.nextNode() || ahn.prevNode()
    @activateNode(next, focus: true)
    Ember.run => ahn.get('nodeParent')?.deleteChild ahn
