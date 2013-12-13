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

Humon.Goal = Humon.Complex.extend()

Humon.Goal.reopenClass
  childMetatemplates:
    goal:
      name: "String"
    completed:
      name: "Boolean"
    completed_at:
      name: "DateTime"

  requiredAttributes: ["goal"]
  optionalAttributes: ["completed", "completed_at"]
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      goal: "Enter your goal"
    return $.extend(requiredDefaults, json)
