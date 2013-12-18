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

Humon.Goal = Humon.Complex.extend()

Humon.Goal.reopenClass
  childMetatemplates:
    goal:
      name: "string"
    completed:
      name: "boolean"
    completed_at:
      name: "date"

  requiredAttributes: ["goal"]
  optionalAttributes: ["completed", "completed_at"]
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
