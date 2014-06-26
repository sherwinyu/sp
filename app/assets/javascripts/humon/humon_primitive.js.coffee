#= require_self
#= require ./humon_number
#= require ./humon_string
#= require ./humon_boolean
#= require ./humon_null
#= require ./humon_date
Humon.Primitive = Humon.BaseHumonValue.extend Humon.HumonValue,
  _value: null
  # TODO(syu): @TRANSITION
  isLiteral: true
  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  toJson: ->
    @_value
  asString: -> @toJson()

  nextNode: ->

  flatten: ->
    [@node]
  enterPressed: (e, payload) ->
    @get('node').tryToCommit( payload )
    nodeView = @get('node.nodeView')
    Ember.run.scheduleOnce "afterRender", nodeView, ->
      if @get('_templateChanged')
        # Make sure we clear templateChanged after a rerender.
        @set('_templateChanged', false)
        @rerender()
        Ember.run.later => @smartFocus()


  subFieldFocusLost: (e, payload)->
    @get('node').tryToCommit(payload)

  ##
  # @override
  # @return [void]
  validateSelf: ->
    @ensure "Value matches json", @constructor.matchesJson(@_value)

Humon.Primitive.reopenClass
  _klass: ->
    @
  _name: ->
   Em.String.underscore  @_klass().toString().split(".")[1]

  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  #   - metatemplate
  #   - allowInvalid [boolean] if true, allows this node to be invalid
  _j2hnv: (json, context) ->
    if context.node.get('initialized')
      value = @valueFromJson(json, context)
    else
      # If the node isn't initialized yet, then pass through the value
      value = json
    @create(_value: value, node: context.node)

  valueFromJson:(json)  ->
    json

  ##
  # @override
  matchesJson: (json) ->
    typeof json == @_name()

  ##
  # By default, we want baseJson for literals to simply
  # be undefined
  # @override
  _baseJson: (json) ->
    undefined
