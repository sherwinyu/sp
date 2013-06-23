Sysys.DetailController = Ember.ObjectController.extend
  init: ->
    @_super()

  anims: {}
  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNodeView: null
  activeHumonNode: null

  ######################################
  ##  Committing (keys and values)
  ######################################

  # commitEverything --
  # param payload: an object with the following properties
  #   node: a HumonNode that describes which node to commit the values to;
  #     defaults to activeHumonNode
  #   key: the key for this humon node. If present, the node's nodeKey is set.
  #   val: the val to be commitd to the node.
  # Behavior:
  #   1) it uses node or defaults it to activeHumonNode
  #   2) it commits the nodeKey
  #   3) it calls commitVal with the val
  # #TODO(syu): refactor so commitVal and commitKey are balanced
  commitEverything: (payload) ->
    node = payload.node || @get('activeHumonNode')
    node.set('nodeKey', payload.key) if payload.key?
    @commitVal payload.val, node: node

  commitAndContinueNew: (payload) ->
    ahn = @get 'activeHumonNode'
    @commitEverything(payload)
    Ember.run.sync()
    parent = ahn.get 'nodeParent'
    idx = ahn.get('nodeIdx') + 1
    if ahn.get 'isCollection'
      parent = ahn
      idx = ahn.get('nodeVal').length
    blank = (Sysys.j2hn "")
    Ember.run => parent.insertAt(idx,  blank)
    @activateNode blank
    Ember.run.sync()
    @smartFocus()

  commitAndContinue: (rawString)->
    ahn = @get 'activeHumonNode'
    # rawString =  @get('activeHumonNodeView').$valField().val() || '{}'
    rawString ||= '{}'
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

  commit: (rawString)->
    # rawString =  @get('activeHumonNodeView').$valField().val()
    @commitVal rawString

  commitKey: ->
    rawString =  @get('activeHumonNodeView').$keyField().val()
    if rawString?
      # TODO(syu): validate whether rawString can be a key
      @set('activeHumonNode.nodeKey', rawString)
    # TODO(syu): refresh key field

  # commitVal -- commits the val
  # precondition: activeNode is a literal
  # param rawString: the rawString to parse and replace ahn with
  # param options: options hash with
  #   node: the node to comit to. defaults to activeHumonNode
  #   rerender: whether to rerender the humon node view
  # TODO(syu):  specify behavior strictly
  commitVal: (rawString, {rerender, node}={rerender: false, node: null}) ->
    node ||= @get('activeHumonNode')
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
        node.replaceWithJson json
        if rerender
          node.rerender()

  commitWithRerender: (rawString) ->
    @commitVal rawString, rerender:true
    @smartFocus()

  ######################################
  ##  Manipulating focus
  #####################################

  smartFocus: ->
    console.log "DC#smartFocus; ahn = #{@get 'activeHumonNode.nodeKey'}; ahnv = ", @get('activeHumonNodeView').$()
    @get('activeHumonNodeView').smartFocus()
    return
  ###
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
    @set 'activeHumonNode', node if node && !node.get('hidden')
    if node and focus
        @smartFocus()

  # nextNode -- controler method for shifting the active node up or down
  # does NOT affect the UI focus
  #
  # @returns newNode -- the new active humon node, or null if no such node exists
  #   1) fetches  @activeHumonNode.nextNode()
  #   2) activates that node if it's non null
  nextNode: ->
    oldNode = @get('activeHumonNode')
    newNode = @get('activeHumonNode').nextNode()
    if newNode
      @activateNode newNode
    console.log "DC#nextNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode


  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    if newNode
      @activateNode newNode
    console.log "DC#prevNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode

  withinScope: (testNode) ->
    return false unless testNode instanceof Sysys.HumonNode
    !!@get('content').pathToNode testNode

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
    destParent = dest?.get('nodeParent')
    return unless @withinScope destParent
    @get('anims').destroy = 'disappear'
    @get('anims').insert  = 'slideUp'
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      dest.get('nodeParent').insertAt(dest.get('nodeIdx'), ahn)
    @activateNode ahn
    @smartFocus()

  bubbleDown: ->
    ahn = @get 'activeHumonNode'
    dest = @get('activeHumonNode').lastFlattenedChild().nextNode()
    destParent = dest?.get('nodeParent')
    return unless @withinScope destParent
    @get('anims').destroy = 'disappear'
    @get('anims').insert  = 'slideDown'
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      if dest.get('isLiteral')
        destParent.insertAt(dest.get('nodeIdx') + 1, ahn)
      else
        dest.insertAt(0, ahn)
    @activateNode ahn
    @smartFocus()

  deleteActive: ->
    ahn = @get('activeHumonNode')
    @set('activeHumonNode', null)
    Ember.run.sync()
    next = ahn.prevNode() || ahn.nextNode()
    return unless next
    Ember.run => ahn.get('nodeParent')?.deleteChild ahn
    @activateNode(next) # , focus: true, unfocus: false)
    Ember.run.sync()
    @smartFocus()

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

Sysys.ActController = Sysys.DetailController.extend
  content: null
  contentDidChange: (->
    chain = Sysys.j2hn({})
    model = @get('content')
    description = model.get 'description'
    description.set 'nodeKey', 'description'
    start_time = model.get 'start_time'
    start_time.set 'nodeKey', 'start time'
    end_time = model.get 'end_time'
    end_time.set 'nodeKey', 'end time'
    detail = model.get 'detail'
    detail.set 'nodeKey', 'details'
    chain.insertAt 0, description, start_time, end_time, detail
    @set 'chain', chain
    chain.set 'hidden', true
  ).observes 'content'

  setTransaction: (->
    if @get('content').transaction.get('isDefault')
      @set('tx', @get('store').transaction())
      @get('tx').add @get('content')
  ).observes('content')

  commitAct: ->
    if @get('content.isDirty')
      @get('content').transaction.commit()
      # @get('content').save()
  forceDirty: (attributeName) ->
    # TODO(syu): refactor to take a 'mid back' function,
    # sandwiched between the willSetProperty and didSetProperty calls
    record = @get('content')
    ctx =
      name: attributeName
      reference: record.get('_reference')
      store: record.store
    record.send 'willSetProperty', ctx
    ctx = name: attributeName
    record.send 'didSetProperty', ctx

  commit: (rawString)->
    @_super(rawString)
    key = @get('activeHumonNode.nodeKey')
    @forceDirty key.replace(' ', '_')

  withinScope: -> false
