#= require_self
#= require ./humon_number
#= require ./humon_string
#= require ./humon_boolean
#= require ./humon_null
#= require ./humon_date
Humon.Primitive = Ember.Object.extend Humon.HumonValue,
  _value: null
  # TODO(syu): @TRANSITION
  isLiteral: true
  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  toJson: ->
    @_value
  asString: ->
    @toJson()
  nextNode: ->
  flatten: ->
    [@node]

Humon.Primitive.reopenClass
  _klass: ->
    @
  _name: ->
   Em.String.underscore  @_klass().toString().split(".")[1]

  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  j2hnv: (json, context) ->
    if context.metatemplate?
      Em.assert("context.metatemplate specified but doesn't match this class!", context.metatemplate.name == @_name() )
      if !@matchesJson json
        json = @_coerceToValidJsonInput json
    json = @_initJsonDefaults json

    @_klass().create(_value: json, node: context.node)

  ##
  # Does NOT trigger validations
  matchesJson: (json) ->
    typeof json == @_name()

  ##
  # @param [json] json
  # @return [json] -- valid json input
  # This is called by j2hnv
  # Used when metatemplate is given (type is known)
  # but matchesJson is false.
  #   E.g., user types "[1,2,3]"
  #     json is the array, [1, 2, 3]
  #     But since we know it cant' be an array, we'll represent it as "[1, 2, 3]"
  # By default, throws an error
  _coerceToValidJsonInput: (json) ->
    throw new Error "Can't coerce #{JSON.stringify json} to #{@}"

  _initJsonDefaults: (json) ->
    json
