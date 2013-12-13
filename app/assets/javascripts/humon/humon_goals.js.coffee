Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node {}, type: Humon.Goal
    @insertAt(idx, blank)
    return blank

Humon.Goals.reopenClass
  requiredAttributes: ["goal", "completed"]

  # @override
  _initJsonDefaults: (json) ->
    json ||= []

Humon.Goal = Humon.Complex.extend

  # @override
  insertNewChildAt: (idx) ->
    null

Humon.Goal.reopenClass
  childMetatemplates:
    goal:
      name: "String"
    completed:
      name: "Boolean"
    completed_at:
      name: "DateTime"

  requiredAttributes: ["goal"]
  optionalAttributes: ["completed", "completedAt"]
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
