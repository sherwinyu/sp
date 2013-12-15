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
  node: null
  controllerBinding: 'node.nodeView.controller'
  name: ->
    # TODO(syu): test this
    # TODO(syu): switch over to using the underscored version
    Ember.String.underscore @.constructor.toString().split(".")[1]
    # @.constructor.toString().split(".")[1].toLowerCase()
  asString: ->
  nextNode: ->
  prevNode: ->
  delete: ->

  enterPressed: ->
    true
  ##
  # Attempts to coerce the input string `jsonInput` to become this type.
  # This is called when trying to commit on a node that is already this HumonValue type.
  # It should mostly be used for more complex objects, e.g. dates:
  #
  #   "8/4" might not be specific enough to qualify as a date
  #   but if we already know the node is a date, "8/4" can be
  #   parsed to August 4th.
  #
  # TODO(syu): What about the general case, if we node the nodeTemplate but the
  # NodeVal isn't instantiated yet? E.g., inside json2node
  #
  # TODO(syu): Impose the invariant that if this.matchesJson(jsonInput), then
  # this.precommitInputCoerce(json) should be true as well
  #
  # @param [JSON] jsonInput
  # @return [boolean] whether the precommitInputCoerce was successful
  precommitInputCoerce: (jsonInput) ->
    false

  ##
  # @return [JSON] json
  toJson: ->

Humon.HumonValueClass = Ember.Mixin.create
  j2hnv: (json) ->

  matchesJson: (json) ->

  coerceToDefaultJson: (json) ->
    throw new Error "Can't coerce #{json} to #{@.constructor}"

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
