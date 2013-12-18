Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node undefined, metatemplate: {name: "goal"}
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

  $completed_at: (->
    @_getChildByKey('completed_at')
  ).property('_value', '_value.@each')

  completed_at: ( (key, value, oldValue) ->
    node = @get('$completed_at')

    # Handle case when node doesn't yet exist?
    # Factor node templates into this.
    # We can leverage existing validation / type checking via tryToCommit
    # Setter
    if arguments.length > 1
      node.tryToCommit val: value
    # Getter
    else
      node = @get('$completed_at')
      node.val()
  ).property('$completed_at')

  $goal: (->
    @_getChildByKey('goal')
  ).property('_value', '_value.@each')

  goal: ( (key, value, oldValue) ->
    node = @get('$goal')

    # Handle case when node doesn't yet exist?
    # Factor node templates into this.
    # We can leverage existing validation / type checking via tryToCommit
    # Setter
    if arguments.length > 1
      node.tryToCommit val: value
    # Getter
    else
      node = @get('$goal')
      node.val()
  ).property('$goal')

  _getChildByKey: (key) ->
    @_value.findProperty('nodeKey', key)

  unknownProperty: null

  enterPressed: ->
    if @get('done')
      @set('completed_at', null)
    else
      @set('completed_at', new Date())
    false

Humon.Goal.reopenClass

  childMetatemplates:
    goal:
      name: "text"
    completed_at:
      name: "date"

  requiredAttributes: ["goal"]

  optionalAttributes: ["completed", "completed_at"]

  directAttributes: ["completed_at"]

  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
