# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  enableLogging: true
  stateManager: null
  activeHumonNodeViewBinding: Ember.Binding.oneWay 'activeHumonNode.nodeView'
  activeHumonNode: null

  commitAndContinue: ->
    next = @get('activeHumonNode').nextNode()
    @commitChanges()
    last = next.prevNode()
    @set('activeHumonNode', last)

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
    @unfocus()

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('.content-field').first().val rawString
    @unfocus()
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

  unfocus: ->
    @get('activeHumonNodeView').$('input').blur()
    @get('activeHumonNodeView').$('textarea').blur()

  nextNode: ->
    newNode = @get('activeHumonNode').nextNode()
    if newNode 
      @set('activeHumonNode', newNode)

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    if newNode 
      @set('activeHumonNode', newNode)

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
