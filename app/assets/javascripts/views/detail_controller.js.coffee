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
    blank = (Sysys.j2hn " ").set('nodeKey', '')
    Ember.run =>
      parent.replaceAt(idx, 0, blank)
    
    @activateNode blank
    @focusActiveNodeView()

  # precondition: activeNode is a literal
  # does jsonparsing of current activeHumonNodeView content field
  # calls replaceWithJson on activeNode
  # postcondition: all text fields are unfocused
  # returns: the parsed nodes
  commitChanges: ->
    Em.assert 'activeHumonNode needs to be a literal to commitChanges', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNodeView').$('> .content-field.literal').first().val()
    json = JSON.parse rawString
    Ember.run =>
      @get('activeHumonNode').replaceWithJson json

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('> .content-field.literal').first().val rawString
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

  unfocus: ->
    @get('activeHumonNodeView').$('input').blur()
    @get('activeHumonNodeView').$('textarea').blur()

  focusActiveNodeView: ->
    ahn = @get('activeHumonNode')
    ahnv = @get('activeHumonNodeView')
    nodeKey = ahn.get('nodeKey')
    nodeVal = ahn.get('nodeVal')

    if nodeKey? && nodeKey == ''
      console.log 'focusing key field'
      @focusKeyField()

    if nodeKey? && ahn.get('isCollection')
      @focusKeyField()

    if nodeKey? && nodeKey != ''
      console.log 'focusing val field'
      @focusValField()

    if !nodeKey 
      console.log 'focusing val field'
      @focusValField()

  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$('> .content-field.key').first()
    $kf.focus()
  focusValField: ->
    $vf = @get('activeHumonNodeView').$('> .content-field.literal').first()
    $vf.focus()
    ###
    if $cf.length
      console.log '$cf.val', $cf.val()
      console.log 'ahn.json', @get('activeHumonNode.json')
      e  = jQuery.Event "focus"
      e.eventData = suppress: true
      $cf.trigger e
      ###

  # sets activeHumonNode to node if node exists
  activateNode: (node, {focus} = {focus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusActiveNodeView()

  nextNode: ->
    # @unfocus()
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    # @unfocus()
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
