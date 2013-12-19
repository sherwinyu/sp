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

  ##
  # @override
  # @callsSuper
  # @return nothing
  validateSelf: ->
    @_super()

  _depDepProp: []
  depProp: (->
    @get('_depDepProp')
  ).property('_depDepProp', '_depDepProp.@each')

  testMe: (->
    "#{@get 'zug'} a bug"
  ).property('zug')

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

  $completed_at: ((key, value, oldValue) ->
    console.log key, value, oldValue
    # Setter
    if arguments.length > 1
      @_setChildByKey(key, value)
    # Getter
    else
      node = @_getChildByKey('completed_at')
  ).property('_value', '_value.@each', '_depDepProp', '_depDepProp.@each')

  completed_at: ( (key, value, oldValue) ->
    console.log key, value, oldValue
    node = @get('$completed_at')

    # Handle case when node doesn't yet exist?
    # Factor node templates into this.
    # We can leverage existing validation / type checking via tryToCommit
    # Setter
    if arguments.length > 1
      if value == undefined
        @deleteChild(node)
        return
      if node?
        node.tryToCommit val: value
      else
        node = Humon.j2n value, metatemplate: @constructor.childMetatemplates['completed_at']
        node.set 'nodeKey', 'completed_at'
        @set('$completed_at', node)
    # Getter
    else
      node = @get('$completed_at')
      node?.val()
  ).property( '_value', '_value.@each', '_depDepProp', '_depDepProp.@each')

  $goal: ( (key, value, oldValue) ->
    console.log key, value, oldValue
    # Setter
    if arguments.length > 1
      @_setChildByKey(key, value)
    # Getter
    else
      @_getChildByKey('goal')
  ).property('_value', '_value.@each').volatile()

  goal: ( (key, value, oldValue) ->
    console.log key, value, oldValue
    node = @get('$goal')

    # Handle case when node doesn't yet exist?
    # Factor node templates into this.
    # We can leverage existing validation / type checking via tryToCommit
    # Setter
    if arguments.length > 1
      if value == undefined
        @deleteChild(node)
        return
      if node?
        node.tryToCommit val: value
      else
        node = Humon.j2n value, metatemplate: @constructor.childMetatemplates['goal']
        node.set 'nodeKey', 'goal'
        @set('$goal', node)

    # Getter
    else
      node = @get('$goal')
      node?.val()
  ).property('$goal', '$goal._value').volatile()

  _getChildByKey: (key) ->
    @_value.findProperty('nodeKey', key)

  _setChildByKey: (key, node) ->
    # remove it:
    node = @_value.findProperty('nodeKey', key)
    Em.assert "Node #{node} must be of type Humon.Node", node instanceof Humon.Node
    if node?
      @_value.removeObject(node)
    @_value.pushObject node

  unknownProperty: null

  getProps: ->
    @get 'goal'
    @get '$goal'
    @get 'completed_at'
    @get '$completed_at'


Humon.Goal.reopenClass

  childMetatemplates:
    goal:
      name: "text"
    completed_at:
      name: "time"

  _j2hnv: (json, context) ->
    value = @valueFromJson(json, context)
    nodeVal = @create(_value: value, node: context.node)
    nodeVal.getProps()
    nodeVal

  requiredAttributes: ["goal"]

  optionalAttributes: ["completed", "completed_at"]

  directAttributes: ["completed_at"]

  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
