Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: [
    'content.isLiteral:node-literal:node-collection',
    'isActive:active']
  classNames: ['node']

  json_string: (->
    JSON.stringify @get('content.json')
  ).property('content.json')

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
    ret
  ).property('controller.activeHumonNode')

  willDestroyElement: ->
    @get('content')?.set 'nodeView', null
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250

  didInsertElement: ->
    @initHotkeys()
    @get('content')?.set 'nodeView', @
    @$().slideUp 0
    @$().slideDown 250

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>
      console.log 'zup'

###
 EVENTS

Specific behaviors:
  WHEN I hit enter
    

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

hash:
  h1: true
  h2: true
  c3:
