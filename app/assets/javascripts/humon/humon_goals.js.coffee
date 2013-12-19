Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node undefined, metatemplate: {name: "goal"}, allowInvalid: true
    @insertAt(idx, blank)
    return blank

  validateSelf: ->
    @_super()
    @ensure "Must have at least 2 goals", @_value.length > 1

Humon.Goals.reopenClass
  requiredAttributes: ["goal", "completed"]
  childMetatemplates:
    $each:
      name: "goal"

  # @override
  _initJsonDefaults: (json) ->
    json ||= []

Humon.Goal = Humon.Complex.extend
  _value: null

  completedTimestamp: (->
    t = @get('completed_at')
    if t instanceof Date
      utils.time.humanized(t)
    else
      "invalid"
  ).property('completed_at')

  done: ( (key, value) ->
    !!@get('completed_at')
  ).property('completed_at')

  enterPressed: ->
    if @get('done')
      @set('completed_at', undefined)
    else
      @set('completed_at', new Date())
    false

  _getChildByKey: (key) ->
    @_value.findProperty('nodeKey', key)

  _setChildByKey: (key, node) ->
    Em.assert "Node #{node} must be of type Humon.Node", node instanceof Humon.Node
    # remove it:
    oldNode = @_value.findProperty('nodeKey', key)
    if oldNode?
      @_value.removeObject(oldNode)
    @_value.pushObject node

  unknownProperty: null

Humon.Goal.reopenClass
  childMetatemplates:
    goal:
      name: "text"
    completed_at:
      name: "time"

  requiredAttributes: ["goal"]

  optionalAttributes: ["completed", "completed_at"]

  directAttributes: ["completed_at"]

  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return _.extend(requiredDefaults, json)

  _generateAccessors: ->
    for key of @childMetatemplates
      methods = {}
      methods[key] = Humon.valAttr(key)
      methods["_" +key] = Humon.nodeAttr(key)
      @reopen methods

Humon.Goal._generateAccessors()
