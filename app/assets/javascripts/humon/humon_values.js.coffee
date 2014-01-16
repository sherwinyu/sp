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

Humon.BaseHumonValue = Ember.Object.extend()
Humon.BaseHumonValue.reopenClass
  ##
  # @param [JSON] json the json expresssion to attempt to convert.
  # @param context
  #
  # Result of this attempt can be:
  #   1) a Humon.Value with its node.notInitialized set to true
  #   1) a Humon.Value that passes matchesJson
  tryJ2hnv: (json, context) ->
    console.warn "No context.node found" unless context?.node?
    validatedJson = @normalizeJson(json, context)
    return @_j2hnv(validatedJson, context)

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

  ##
  # @param [JSON] json
  # @return [boolean]
  # Checks whether the json expression could possibly become converted to this type.
  # This is a fairly loose expectation; type conversions should be considered as well.
  # This also must be error tolerant and not throw any errors!
  #
  # For example, Humon.Time.matchesJson("8:40") is true.
  #
  # matchesJson provides a guarantee that _j2hnv will return successfully.
  matchesJson: (json) -> Em.assert("matchesJson needs to be implemented")

  ##
  # Calls @create, passing it a value taken from @valueFromJson, with proper node
  #
  # @param [JSON] json
  # @param [JSON] context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  #   - metatemplate
  #   - allowInvalid [boolean] if true, allows this node to be invalid
  _j2hnv: (json, context) -> Em.assert("_j2hnv needs to be implemented")

  ##
  # @param [JSON] json
  # @return [JSON] json
  # Return the most basic json for this type. This does not necessarily
  # return true for matchesJson, nor is it necessarily valid.
  # This is returned for cases when context.allowInvalid is true
  _baseJson: (json) -> Em.assert "_baseJson needs to be implemented"

  ##
  # PRE CONDITION: matchesJson(json) is true
  # returns a VALID _value
  # @return [?] a valid _value, such that a nodeVal created with this _value
  # should pass validateSelf
  valueFromJson: (json, context) -> Em.assert "must implement"

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

Humon.HumonValue = Ember.Mixin.create
  node: null
  controllerBinding: 'node.nodeView.controller'

  _errors: null

  ##
  # Called by HNV.focusOut
  # @param [event] e
  # @param [JSON] payload
  #   - key: value of the Key subfield
  #   - val: value of the Val subfield
  subFieldFocusLost: (e, payload)->
    console.warn "#{@constructor} should implement subFiledFocusLost"

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
  # @return [void]
  validateSelf: ->
    Em.assert "Need to implement validate self"

  ##
  # Assert-style validations
  # @param [String] the reason the assertion is failing
  # @param [boolean] assertion that must be true to avoid an error
  ensure: (explanation, assertion) ->
    unless @_errors?
      console.warn "Initializing default @_errors array for explanation: #{explanation}"
    @_errors || = []
    @_errors.push explanation unless assertion

  name: ->
    Ember.String.underscore @.constructor.toString().split(".")[1]
  asString: -> Em.assert "needs to be implemented"
  nextNode: -> Em.assert "needs to be implemented"
  prevNode: -> Em.assert "needs to be implemented"
  delete: -> Em.assert "needs to be implemented"
  toJson: ->
    Em.assert "needs to be implemented"

  enterPressed: ->
    true

  deletePressed: ->
    @get('node.nodeParent.nodeVal')?.deleteChild(@get('node'))

