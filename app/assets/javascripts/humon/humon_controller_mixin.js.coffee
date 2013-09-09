Sysys.HumonControllerMixin = Ember.Mixin.create
# content:  the root HumonNode

  activeHumonNodeViewBinding: 'activeHumonNode.nodeView'
  activeHumonNodeView: null
  activeHumonNode: null
  init: ->
    @_super()
    hooks = @get('hooks') || {}
    if typeof hooks.didCommit is 'function'
      @didCommit = hooks.didCommit
    if typeof hooks.didUp is 'function'
      @didUp = hooks.didUp
    if typeof hooks.didDown is 'function'
      @didDown = hooks.didDown

  ###################
  # HOOKS
  ##################

  # params:
  #   - controller: the instance of the controller
  #   - node: the committed node
  #   - rootJson: json representation of the root node
  #   - key: a string if the key was committed; null otherwise
  didCommit: (params)->
    console.log 'didCommit', JSON.stringify rootJson

  didUp: ->
    console.log 'didUp'
  didDown: ->
    console.log 'didDown'

  actions:
    ######################################
    ##  Committing (keys and values)
    ######################################

    # commitEverything --
    # param payload: an object with the following properties
    #   node: a HumonNode that describes which node to commit the values to;
    #     defaults to activeHumonNode
    #   key: the key for this humon node. If present, the node's nodeKey is set.
    #   val: the val to be commitd to the node. If present, the commitVal is called.
    #
    # Behavior:
    #   1) it uses node or defaults it to activeHumonNode
    #   2) it commits the nodeKey if key is present
    #   3) it calls _commitVal with the val if val is present
    #
    # Context:
    #   commitEverything is the central pathway for all commiting.
    #   it fires the didCommit hook
    #   called by:
    #     - `commitAndContinueNew`, prior to inserting blank
    #     - `HNV#focusOut`
    commitEverything: (payload) ->
      node = payload.node || @get('activeHumonNode')
      node.set('nodeKey', payload.key) if payload.key?
      @_commitVal payload.val, node: node if payload.val?
      @didCommit(
        controller: @
        node: node
        rootJson: Sysys.hn2j @get('content')
        payload: payload
      )

    # all this does is SETS THE NODE TO ACTIVE
    # does NOT focus
    # does NOT commit
    # does NOT check if node is null TODO(syu): split into a deactivateNode action
    activateNode: (node) ->
      @set 'activeHumonNode', node

    smartFocus: ->
      @get('activeHumonNodeView').smartFocus()


    # calls commitEverything
    # then, if the active (just committed) node is a collection,
    #   we switch to insertChild
    # otherwise,
    #   insert a sibling after the active node
    # then conditionally decides whether to insert a sibling or a child,
    # depending on whether active node is a collection
    commitAndContinueNew: (payload) ->
      ahn = @get 'activeHumonNode'
      @send 'commitEverything', payload
      Ember.run.sync()
      if ahn.get 'isCollection'
        @send 'activateNode', ahn
        @insertChild()
        return
      blank = Sysys.j2hn null
      Ember.run =>
        parent = ahn.get 'nodeParent'
        idx = ahn.get('nodeIdx') + 1
        parent.get('nodeView').rerender()
        parent.insertAt(idx,  blank)
      @send 'activateNode', blank
      Ember.run.sync()
      @send 'smartFocus'

  # _commitVal -- commits the val
  # precondition: activeNode is a literal
  # param rawString: the rawString to parse and replace ahn with
  # param options: options hash with
  #   node: the node to comit to. defaults to activeHumonNode
  #   rerender: whether to rerender the humon node view
  # TODO(syu):  specify behavior strictly
  _commitVal: (rawString, {node}={node: null}) ->
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
        newType = node.get("nodeType")
        # rerender this node; _focusField will get us properly refocused
        # We are manually re-rendering to update autoTemplate.
        # But we don't want to rerender if we're still on the same humon node --
        #   because if we do, we can't "right arrow" into the next field -- it'll have been removed!
        # Also, add the ?. check on nodeView because in the case of dC.delete, the node already has
        # nodeView set to null from HNV#willDeleteElement
        if newType != oldType
          node.get('nodeView')?.rerender()

######################################
##  Setting Active Node
######################################

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
    else
      @didDown()
    console.log "DC#nextNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    if newNode
      @send 'activateNode', newNode
    else
      @didUp()
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
    Ember.run.sync()
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
    Ember.run.sync()
    @send 'smartFocus'

  deleteActive: ->
    ahn = @get('activeHumonNode')
    @set('activeHumonNode', null)
    Ember.run.sync()
    next = ahn.prevNode() || ahn.nextNode()
    return unless next && ahn.get('nodeParent')
    Ember.run => ahn.get('nodeParent')?.deleteChild ahn
    @send 'activateNode', next
    Ember.run.sync()
    @send 'smartFocus'

  # insertChild
  #   inserts and sets focus on a blank node that is a child
  #   of the active node, which must be a collection.
  insertChild: ->
    ahn = @get('activeHumonNode')
    Em.assert 'humon node should be a collection', ahn.get('isCollection')
    blank = Sysys.j2hn null
    Em.run => ahn.insertAt 0, blank
    @send 'activateNode', blank
    Ember.run.sync()
    @send 'smartFocus'

  outdent: ->
    ahn = @get 'activeHumonNode'
    newSibling = ahn.get 'nodeParent'
    newParent = newSibling?.get 'nodeParent'
    return unless newParent and newSibling
    Ember.run =>
      newSibling.deleteChild ahn
      newParent.insertAt newSibling.get('nodeIdx') + 1, ahn
      @send 'activateNode', ahn
    @send 'smartFocus'

  indent: ->
    ahn = @get 'activeHumonNode'
    parent = ahn.get('nodeParent')
    prevSib = parent?.get('nodeVal')[ ahn.get('nodeIdx') - 1]
    return unless prevSib && prevSib.get('isCollection')
    Ember.run =>
      parent.deleteChild ahn
      prevSib.insertAt prevSib.get('nodeVal.length'), ahn
      @send 'activateNode', ahn
    @send 'smartFocus'
