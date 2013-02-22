Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: ['content.isLiteral:node-literal:node-collection']
  classNames: ['node']

Sysys.DetailController = Ember.Object.extend
  enableLogging: true
  stateManager: null
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
            # @set('stateManager', 
          select: (mgr, newNode) ->
            # currentNode.commit()
            # updateNew currentNode to newNode

    @set('stateManager', stateMgr)

###
 EVENTS

On select
  types of select
    up arrow
    down arrow
    click (if not editing)
  update current node

enter (commit and insert new line)
  createNode and selectIt

    what bout new nesting?
