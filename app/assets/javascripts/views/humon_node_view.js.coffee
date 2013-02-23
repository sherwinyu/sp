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
            # can't call commit bc can have selects that don't commit!

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

    what about new nesting?


controller ||| statemgr ||| view 
=======
    what bout new nesting?


====
StateMgr
  
Controller
  currentNode
  parse current value
  all functions for modifying the node structure via replaceAt



HumonNodeView
  click
  key events
    enter
      -> detailscontroller.commitAndInsert
        -> detailscontroller.commit (needs to be in editing mode)
          -> parse current node {
              case -- "[" --> triggers nesting
                 -> setCurrentNodeToArrayType
              case -- "just a literal"
              }
         -> insert new entry after current
         -> select the new line
    up
      -> commit
        -> parse current node
          -> 
    esc
      only if editing::
      -> detailscontroller.cancel
        -> transitionTo active
        -> currentNodeView.cancel

  focus in
    activate ->

    select ->
  focus out
    exit edit

    -> select 
