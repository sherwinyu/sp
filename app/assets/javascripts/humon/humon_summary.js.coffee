Humon.Summary = Humon.Complex.extend
  addField: (e) ->
  # @param [int] idx the index at which to insert.
  # @return [Humon.Node] the inserted childNode
  #   or null, if all optional attributes already exist
  # Automatically finds the first optional attribute
  # that isn't included yet, and inserts that.
  insertNewChildAt: (idx) ->
    # Get an array of unused attribute keys
    unusedAttributeKeys = @constructor.optionalAttributes.filter( (key) =>
      @get(key) == undefined)
    if (key = unusedAttributeKeys[0])?
      blank = Humon.json2node ""
      blank.set "nodeKey", key
      @insertAt(idx, blank)
      return blank
    else
      null


Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: "String"
    worst:
      name: "String"
    funny:
      name: "String"
    insight:
      name: "String"

  requiredAttributes: ["best", "worst"]
  optionalAttributes: ["funny", "insight"]

  # @overrides
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
