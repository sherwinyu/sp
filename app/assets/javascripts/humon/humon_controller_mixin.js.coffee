Humon.HumonControllerMixin = Ember.Mixin.create
# content:  the root HumonNode

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
    # console.log 'didCommit', JSON.stringify rootJson

  didUp: (e)->
    # console.log 'didUp'
  didDown: (e)->
    # console.log 'didDown'

  actions:
    ###
    action activateNode
    @param nodeToActivate

    all this does is SETS THE NODE TO ACTIVE
    does NOT focus
    does NOT commit
    does NOT check if node is null TODO(syu): split into a deactivateNode action
    ###
    activateNode: (node) ->
      @set 'activeHumonNode', node



  withinScope: (testNode) ->
    return false unless testNode instanceof Humon.Node
    !!@get('content').pathToNode testNode

##################################
## Manipulating humon node tree
##################################

###
  ##  Setting Active Node

  # nextNode -- controler method for shifting the active node up or down
  # does NOT affect the UI focus
  #
  # @returns newNode -- the new active humon node, or null if no such node exists
  #   1) fetches  @activeHumonNode.nextNode()
  #   2) activates that node if it's non null
  nextNode: (e)->
    oldNode = @get('activeHumonNode')
    newNode = @get('activeHumonNode').nextNode()
    if newNode
      @send 'activateNode', newNode
    else
      @didDown(e)
      # console.log "DC#nextNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode

  prevNode: (e)->
    newNode = @get('activeHumonNode').prevNode()
    if newNode
      @send 'activateNode', newNode
    else
      @didUp(e)
      # console.log "DC#prevNode; active node key = #{@get('activeHumonNode.nodeKey')}"
    newNode

  smartFocus: ->
    hnv = @get('activeHumonNode.nodeView')
    if hnv?
      hnv.smartFocus()
    else
      console.warn "HumonMixinController.smartFocus, but no nodeView found for node:", @get('activeHumonNode')

  bubbleUp: ->
    ahn = @get('activeHumonNode')
    dest = @get('activeHumonNode').prevNode()
    destParent = dest?.get('nodeParent')
    return unless @withinScope destParent
    Ember.run =>
      ahn.get('nodeParent.nodeVal').deleteChild ahn
      dest.get('nodeParent.nodeVal').insertAt(dest.get('nodeIdx'), ahn)
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
    newChildNode = null
    Em.run => newChildNode = ahn.get('nodeVal').insertNewChildAt(0)
    @send 'activateNode', newChildNode
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
    prevSib = parent?.get('children')[ ahn.get('nodeIdx') - 1]
    return unless prevSib && prevSib.get('isCollection')
    Ember.run =>
      parent.deleteChild ahn
      prevSib.insertAt prevSib.get('children.length'), ahn
      @send 'activateNode', ahn
    @send 'smartFocus'
###
