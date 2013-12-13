Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node
      goal: "Enter your goal", completed: false
    @insertAt(idx, blank)
    return blank

Humon.Goals.reopenClass
  requiredAttributes: ["goal", "completed"]

  # @override
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      best: ""
      worst: ""
    # assuming json has no other fields
    # assuming json.best and json.worst are Strings
    # assuming json.funny, json.insight are Strings -- THIS ASSUMPTION
    #   is NOT true because they default to Null!
    # assuming json is an object
    return $.extend(requiredDefaults, json)

Humon.Goal = Humon.Complex.extend
  # @override
  insertNewChildAt: (idx) ->
    null

Humon.Goal.reopenClass

