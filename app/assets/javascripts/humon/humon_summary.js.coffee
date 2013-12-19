Humon.Summary = Humon.Complex.extend()

Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: "text"
    worst:
      name: "text"
    funny:
      name: "text"
    insight:
      name: "text"

  requiredAttributes: ["best", "worst"]
  optionalAttributes: ["funny", "insight"]

  ##
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

Humon.Summary._generateAccessors()
