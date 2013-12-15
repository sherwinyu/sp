#= require_self
#= require ./humon_primitive
#= require ./humon_list
#= require ./humon_hash
#= require ./humon_complex
#= require ./humon_sleep
#= require ./humon_summary
#= require ./humon_time
#= require ./humon_goals

Humon.HumonValue = Ember.Mixin.create
  name: ->
    # TODO(syu): test this
    # TODO(syu): switch over to using the underscored version
    Ember.String.underscore @.constructor.toString().split(".")[1]
    # @.constructor.toString().split(".")[1].toLowerCase()
  asString: ->
  nextNode: ->
  prevNode: ->
  delete: ->
  ##
  # @return [JSON] json
  toJson: ->
  node: null

Humon.HumonValueClass = Ember.Mixin.create
  j2hnv: (json) ->
  matchesJson: (json) ->

###
commitEverything: (payload)
  - commitVal
  - setKey

activateNode: (node)

smartFocus:
  hnv.smartFocus

commitLiteral: (payload)
  - commitEveryything
  - activateNode
  - smartFocus

commitAndContinueNew: (payload)
  - commitEverything

  if commited a collection
    - activateNode
    - smartFocus
    - insertChild

  if commited a literal
    - node.nodeVal.insertNewChlidAt
    - activateNode
    - smartFocus

_commitVal: (rawString, node=null)o
  attempts JSON.parse rawString
  node.replaceWithJson
  node.nodeView.rerender (if type changed)

nextNode: (e)
  node.nextNode
  - activateNode

  - didDown

prevNode: (e)
  node.prevNode
  - activateNode

  - didUp

forceHash:

forceList:

bubbleUp:
  - get ahn
  ahn.nodeParent.nodeVal.deleteChild
  ahn.nodeParent.nodeVal.insertAt
  - activateNode
  - smartFocus

bubbleUp:
  - get ahn
  ahn.nodeParent.nodeVal.deleteChild
  ahn.nodeParent.nodeVal.insertAt
  - activateNode
###
