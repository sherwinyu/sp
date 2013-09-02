Sysys.HumonControllerMixin = Ember.Mixin.create
  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNodeView: null
  activeHumonNode: null
  commited: Em.K

  ######################################
  ##  Committing (keys and values)
  ######################################

  # commitEverything --
  # param payload: an object with the following properties
  #   node: a HumonNode that describes which node to commit the values to;
  #     defaults to activeHumonNode
  #   key: the key for this humon node. If present, the node's nodeKey is set.
  #   val: the val to be commitd to the node. If present, the commitVal is called.
  # Behavior:
  #   1) it uses node or defaults it to activeHumonNode
  #   2) it commits the nodeKey if key is present
  #   3) it calls commitVal with the val if val is present
  # #TODO(syu): refactor so commitVal and commitKey are balanced
  commitEverything: (payload) ->
    node = payload.node || @get('activeHumonNode')
    node.set('nodeKey', payload.key) if payload.key?
    @send 'commitVal', payload.val, node: node if payload.val?

  commitAndContinueNew: (payload) ->
    ahn = @get 'activeHumonNode'
    @send 'commitEverything', payload
    Ember.run.sync()
    parent = ahn.get 'nodeParent'
    idx = ahn.get('nodeIdx') + 1
    if ahn.get 'isCollection'
      parent = ahn
      idx = ahn.get('nodeVal').length
    blank = (Sysys.j2hn null)
    Ember.run =>
      console.debug "nodeView rerender: commitAndContinueNew", ts()
      parent.get('nodeView').rerender()
      parent.insertAt(idx,  blank)
    @send 'activateNode', blank
    Ember.run.sync()
    @send 'smartFocus'

  commit: (rawString)->
    # rawString =  @get('activeHumonNodeView').$valField().val()
    @send 'commitVal', rawString

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
  commitVal: (rawString, {rerender, node}={rerender: true, node: null}) ->
    node ||= @get('activeHumonNode')
    oldType = node.get('nodeType')
    json =
      try
        humon.parse rawString
      catch error
        try
          JSON.parse rawString
        catch error
          rawString
    if rawString?
      Ember.run =>
        node.replaceWithJson json
        @committed()
        newType = node.get('nodeType')
        if newType != oldType
        # We are manually re-rendering to update autoTemplate.
        # But we don't want to rerender if we're still on the same humon node --
        #   because if we do, we can't "right arrow" into the next field -- it'll have been removed!
        # Als o, add the ?. check on nodeView because in the case of dC.delete, the node already has
        # nodeView set to null from HNV#willDeleteElement
          node.get('nodeView')?.rerender() && console.debug("nodeView rerender:commitVal", ts()) # unless node == @get('activeHumonNode')

  commitWithRerender: (rawString) ->
    @send 'commitVal', rawString, rerender:true
    @send 'smartFocus'

  ######################################
  ##  Manipulating focus
  #####################################

  smartFocus: ->
    @get('activeHumonNodeView').smartFocus()
    return

  focusLabelField : ->
    #$lf = @get('activeHumonNodeView').$labelField().focus()
    @get('activeHumonNodeView').focusField('label')
  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$keyField().focus()
  focusValField: ->
    @get('activeHumonNodeView').focusField('val')
    #$vf = @get('activeHumonNodeView').$valField().focus()
  focusIdxField: ->
    # @get('activeHumonNodeView').focusField('label')
    $if = @get('activeHumonNodeView').$idxField().focus()

######################################
##  Setting Active Node
######################################

  activateNode: (node, {focus, unfocus} = {focus: false, unfocus: false}) ->
    @set 'activeHumonNode', node if node && !node.get('hidden')
    if node and focus
        @send 'smartFocus'

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
      @send 'activateNode', newNode
    console.log "DC#nextNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode


  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    if newNode
      @send 'activateNode', newNode
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
    @send 'smartFocus'

  # Changes context to a hash
  # If activeNode is a literal and activeNode's parent is a list, convert the parent to a hash
  # If activeNode is a list, convert it to a hash
  forceList: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isHash')
      ahn.convertToList()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isHash')
      ahn.get('nodeParent')?.convertToList()
    @send 'smartFocus'

  # TODO(syu): test me
  bubbleUp: ->
    ahn = @get('activeHumonNode')
    dest = @get('activeHumonNode').prevNode()
    destParent = dest?.get('nodeParent')
    return unless @withinScope destParent
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      dest.get('nodeParent').insertAt(dest.get('nodeIdx'), ahn)
    @send 'activateNode', ahn
    @send 'smartFocus'

  bubbleDown: ->
    ahn = @get 'activeHumonNode'
    dest = @get('activeHumonNode').lastFlattenedChild().nextNode()
    destParent = dest?.get('nodeParent')
    return unless @withinScope destParent
    Ember.run =>
      ahn.get('nodeParent').deleteChild ahn
      if dest.get('isLiteral')
        destParent.insertAt(dest.get('nodeIdx') + 1, ahn)
      else
        dest.insertAt(0, ahn)
    @send 'activateNode', ahn
    @send 'smartFocus'

  deleteActive: ->
    ahn = @get('activeHumonNode')
    @set('activeHumonNode', null)
    Ember.run.sync()
    next = ahn.prevNode() || ahn.nextNode()
    return unless next && ahn.get('nodeParent')
    Ember.run => ahn.get('nodeParent')?.deleteChild ahn
    @send 'activateNode', next # , focus: true, unfocus: false)
    Ember.run.sync()
    @send 'smartFocus'

  insertChild: ->
    ahn = @get('activeHumonNode')
    Em.assert 'humon node should be a collection', ahn.get('isCollection')
    nextBlank = (Sysys.j2hn "")
    Em.run => ahn.insertAt 0, nextBlank
    @send 'activateNode', nextBlank, focus: true, unfocus: false

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
