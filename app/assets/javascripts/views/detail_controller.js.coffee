# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  enableLogging: true
  stateManager: null
  activeHumonNodeView: Ember.Binding.oneWay 'activeHumonNode.nodeView'
  activeHumonNode: null

  commitChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNodeView').$('.content-field').first().val()
    json = JSON.parse rawString
    @get('activeHumonNode').replaceWithJson json

  cancelChanges: ->




  insertNewElement: ->
    debugger
    currentNode = @get('currentNode')
    parent = currentNodeget('nodeParent')
    len = parent.get('nodeVal.length')
    empty = Sysys.HumonUtils.json2humonNode('')
    obj = 
      if parent.get('isHash')
        {key: '', val: empty}
      else if parent.get('isList')
        empty
    parent.replaceAt(len, 0, [obj])

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
