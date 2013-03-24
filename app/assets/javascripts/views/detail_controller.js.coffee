# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  enableLogging: true
  stateManager: null
  activeHumonNodeView: (->
    @get('activeHumonNode.nodeView')
  ).property 'activeHumonNode'
  activeHumonNode: null

  commitAndContinue: ->
    next = @get('activeHumonNode').nextNode()
    @commitChanges()
    last = next.prevNode()
    parent = next.get('nodeParent')
    idx = parent.get('nodeVal').indexOf next
    blank = (Sysys.j2hn " ").set('nodeKey', 'new key')
    Ember.run =>
      parent.replaceAt(idx, 0, blank)
    
    @activateNode blank
    @focusValField()

  # precondition: activeNode is a literal
  # does jsonparsing of current activeHumonNodeView content field
  # calls replaceWithJson on activeNode
  # postcondition: all text fields are unfocused
  # returns: the parsed nodes
  commitChanges: ->
    Em.assert 'activeHumonNode needs to be a literal to commitChanges', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNodeView').$('> .content-field').first().val()
    json = JSON.parse rawString
    Ember.run =>
      @get('activeHumonNode').replaceWithJson json

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('> .content-field').first().val rawString
    @unfocus()
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

  unfocus: ->
    @get('activeHumonNodeView').$('input').blur()
    @get('activeHumonNodeView').$('textarea').blur()

  focusValField: ->
    window.zorg = $cf = @get('activeHumonNodeView').$('> .content-field').first()
    if $cf.length
      console.log '$cf.val', $cf.val()
      console.log 'ahn.json', @get('activeHumonNode.json')
      e  = jQuery.Event "focus"
      e.eventData = suppress: true
      $cf.trigger e

      #setTimeout( (-> $cf.trigger(e))
      #, 100)

  # sets activeHumonNode to node if node exists
  activateNode: (node, {focus} = {focus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusValField()

  nextNode: ->
    @unfocus()
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    @unfocus()
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode, focus: true

  init: ->
    stateMgr = Ember.StateManager.create
      initialState: 'inactive'

      inactive: Ember.State.create
        enter: -> console.log 'entering state inactive'
        exit: -> console.log 'exiting state inactive'

      active: Ember.State.create
        enter: -> console.log 'entering state active'
        exit: -> console.log 'exiting state active'

        editing: Ember.State.create
          enter: -> console.log 'entering state editing'
          exit: -> console.log 'exiting state editing'

          select: (mgr, newNode) ->
            # currentNode.commit()
            # updateNew currentNode to newNode
            # can't call commit bc can have selects that don't commit!

    @set('stateManager', stateMgr)
