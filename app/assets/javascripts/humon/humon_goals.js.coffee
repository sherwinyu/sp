Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node undefined, metatemplate: {name: "goal"}, allowInvalid: true, nodeParent: @node
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
Humon.Goal._generateAccessors()

Humon.NodeGoalView = Humon.NodeView.extend()

Humon.NodeGoalDescriptionView = Humon.NodeView.extend
  activateBoundNode: (activate = true) ->
    arg = if activate then @get('nodeContent.nodeParent') else null
    @get('controller').send('activateNode', arg)
