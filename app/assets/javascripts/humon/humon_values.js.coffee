#= require_self
#= require ./humon_primitive
#= require ./humon_list
#= require ./humon_hash
#= require ./humon_complex
#= require ./humon_sleep
#= require ./humon_summary
#= require ./humon_time
#= require ./humon_goals
#= require ./humon_text

Humon.BaseHumonValue = Ember.Object.extend
  _errors: null
  ##
  # Called by HNV.focusOut
  # @param [event] e
  # @param [JSON] payload
  #   - key: value of the Key subfield
  #   - val: value of the Val subfield
  subFieldFocusLost: (e, payload)->
    console.warn "#{@constructor} should implement subFiledFocusLost"
    # Em.assert "Must implement focusOut"

  ##
  # Calls @validateSelf, which can optionally call superclass.validateSelf
  # @return [JSON]
  #   - valid [boolean]
  #   - reasons [Array<String>] reasons List of reasons this is invalid
  validate: ->
    @_errors = []
    @validateSelf()
    ret =
      valid: @_errors.length == 0
      errors: @_errors

  ##
  # @return nothing
  validateSelf: ->
    Em.assert "Need to implement validate self"

  ensure: (string, assertion) ->
    @_errors.push string unless assertion


Humon.BaseHumonValue.reopenClass
  tryJ2hnv: (json, context) ->
    console.warn "No context.node found" unless context?.node?
    validatedJson = @normalizeJson(json, context)

    # TODO(syu): SUPER hacky
    # Basically, if we allowedInvalid in normalizeJson (aka, json is undefined)
    #   AND this is a literal, we want to bypass @_j2hnv
    #   because in the case of Date, we'd do tests on the json.
    #   We can't just ALWAYS bypass @_j2hnv when allowInvalid is true,
    #   because when the node accepts children, we need to convert
    #   {requiredAttribute1: undefined, reqAtr2: undefined} to [node, node]
    return @_j2hnv(validatedJson, context)

  ##
  # @param [JSON] json
  # @param [JSON] context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  #   - metatemplate
  #   - allowInvalid [boolean] if true, allows this node to be invalid
  _j2hnv: (json, context) -> Em.assert("_j2hnv needs to be implemented")

  ##
  # @param [JSON] json
  #
  matchesJson: (json) -> Em.assert("matchesJson needs to be implemented")

  _baseJson: (json) -> Em.assert "_baseJson needs to be implemented"

  ##
  # PRE CONDITION: matchesJson(json) is true
  # returns a VALID _value
  valueFromJson: (json, context) -> Em.assert "must implement"


  ##
  # @param json A JSON payload to be converted into a Humon.Value instance
  # @return [JSON] that matchesJson
  # properly normalized json that has defaults initialized,
  #   and passes @matchesJson

  normalizeJson: (json, context) ->
    typeName = context?.metatemplate?.name
    matched = @matchesJson(json)
    typeSpecified = typeName?
    if matched
      return json
    if not matched and typeSpecified
      if context?.allowInvalid
        context.node.set('notInitialized', true)
        return json = @_baseJson(json)

     throw new Error "JSON #{json} couldn't be coerced into #{@}"
    ###







    if typeName?
      Em.assert("context.metatemplate specified but doesn't match this class!", Humon.contextualize(typeName) == @)

    if !@matchesJson json
     if context?.allowInvalid
        context.node.set('notInitialized', true)
        console.warn "JSON #{JSON.stringify json} should be undefined or null when defaulting to #{@}" if json?
        #Em.assert "JSON must be undefined or null", !json?
        return json = @_initJsonDefaults json

      # Last ditch coerce, or throw the error
      json = @_coerceToValidJsonInput json

    Em.assert "Json should match after coercion", @matchesJson(json)
    json = @_initJsonDefaults json
    ###

  ##
  # @param [json] json
  # @return [json] -- valid json input
  # This is called by _j2hnv
  # Used when metatemplate is given (type is known)
  # but matchesJson is false.
  #   E.g., user types "[1,2,3]"
  #     json is the array, [1, 2, 3]
  #     But since we know it cant' be an array, we'll represent it as "[1, 2, 3]"
  # By default, throws an error
  _coerceToValidJsonInput: (json, context) ->
    throw new Error "Can't coerce #{JSON.stringify json} to #{@}"

  ##
  # @required
  # Contract:
  #   if json is undefined, then initialize it to a base value
  #   then set that base value's defaults
  _initJsonDefaults: -> Em.assert "_initJsonDefaults needs to be implemented"

Humon.HumonValue = Ember.Mixin.create
  node: null
  controllerBinding: 'node.nodeView.controller'
  name: ->
    # TODO(syu): test this
    # TODO(syu): switch over to using the underscored version
    Ember.String.underscore @.constructor.toString().split(".")[1]
    # @.constructor.toString().split(".")[1].toLowerCase()
  asString: -> Em.assert "needs to be implemented"
  nextNode: -> Em.assert "needs to be implemented"
  prevNode: -> Em.assert "needs to be implemented"
  delete: -> Em.assert "needs to be implemented"

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
    Em.assert "needs to be implemented"

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
