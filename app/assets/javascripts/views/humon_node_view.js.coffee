Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: ['content.isLiteral:node-literal:node-collection']
  classNames: ['node']

  initHotkeys: ->


      # keyUp: ->
    ###
      enter: ->
      shift-enter: ->
      esc: ->
    ###
    

  commit: ->
    val = @$('.content-field').first().val()
    json = JSON.parse val
    @get('content').replaceWithJson json
    # TODO(syu): redisplay the content field value?
    # TODO(syu): interface with "next step", e.g., singleline compact parse; should autohighlight next line.
    #
    # is an interface with a state manager really necessary? probably.
    # next step to implement: "find next node, find previous node"

  cancel: ->
    json = @get('content.json')
    @$('.content-field').val json

  didInsertElement: ->
    @initHotkeys()


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

  select: -> 
  commit: ->
  commitAndInsert: ->

HNV
  #applies value to underlying humon node
  
  refresh: ->
    resync ContentFieldVal with text representation of HN

  commit: ->
    @get content .replaceWithJson @get contentfieldval

  # resets value of the contentfield
  cancel: ->
  


    

     
  


  =====
  need an abstraction layer for 
    single line edit views of:
      list item (just a literal)
      kvp item (kvp, literal)
      kvp label (nest)
      list item label (nest)

  ===
  allow controller (detailcontroller) || view abstraction to be general enough to edit ANY mongodb field


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
    up/down
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
