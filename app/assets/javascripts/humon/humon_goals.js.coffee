Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node {}, metatemplate: {name: "goal"}
    @insertAt(idx, blank)
    return blank

Humon.Goals.reopenClass
  requiredAttributes: ["goal", "completed"]
  childMetatemplates:
    $each:
      name: "goal"

  # @override
  _initJsonDefaults: (json) ->
    json ||= []

Humon.Goal = Humon.Complex.extend
  done: ( (key, value) ->
    !!@get('completed_at._value')
  ).property('completed_at', 'completed_at._value')

  enterPressed: ->
    if @get('done')
      @set('completed_at._value', null)
    else
      @get('completed_at').set("_value", new Date())
    false

Humon.Goal.reopenClass

  childMetatemplates:
    goal:
      name: "text"
    completed_at:
      name: "date"

  requiredAttributes: ["goal"]
  optionalAttributes: ["completed", "completed_at"]
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
