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
    @activateNode last 
    @focusValField()
    # @unfocus()

  # precondition: activeNode is a literal
  # does jsonparsing of current activeHumonNodeView content field
  # calls replaceWithJson on activeNode
  # postcondition: all text fields are unfocused
  # returns: the parsed nodes
  commitChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNodeView').$('.content-field').first().val()
    json = JSON.parse rawString
    @get('activeHumonNode').replaceWithJson json

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('.content-field').first().val rawString
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

  unfocus: ->
    @get('activeHumonNodeView').$('input').blur()
    @get('activeHumonNodeView').$('textarea').blur()

  focusValField: ->
    @unfocus()
    $cf = @get('activeHumonNodeView').$('.content-field').first()
    console.log '$cf.val', $cf.val()
    console.log 'ahn.json', @get('activeHumonNode.json')
    $cf.trigger 'focus'

  # sets activeHumonNode to node if node exists
  activateNode: (node) ->
    if node
      @set 'activeHumonNode', node

  nextNode: ->
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode
    # if newNode 
    # @set('activeHumonNode', newNode)
      # @focusValField()

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode
    # if newNode 
    # @set('activeHumonNode', newNode)
    # @focusValField()

   ###
  insertNewElement: ->
    currentNode = @get('currentNode')
    parent = currentNodeget('nodeParent')
    len = parent.get('nodeVal.length')
    empty = Sysys.HumonUtils.json2humonNode('')
    obj = 
      if parent.get('isHash')
        {key: '', val: empty}
      else if parent.get('isList')
        empty
    parent.replaceAt(len, 0, obj)
    ###

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
