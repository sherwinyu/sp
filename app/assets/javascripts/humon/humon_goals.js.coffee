Humon.Goals = Humon.List.extend
  insertNewChildAt: (idx) ->
    blank = Humon.json2node goal: "Enter your goal", completed: false
    @insertAt(idx, blank)
    return blank


Humon.Goals.reopenClass
  childMetatemplates:
    best:
      name: "String"
    worst:
      name: "String"
    funny:
      name: "String"
    insight:
      name: "String"


  # Overrides
  _initJsonDefaults: (json) ->
    json ||= []
