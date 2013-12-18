Humon.Sleep = Humon.Complex.extend(
)
Humon.Sleep.reopenClass
  childMetatemplates:
    awake_at:
      name: "time"
    outofbed_at:
      name: "time"
    awake_energy:
      name: "number"
    outofbed_energy:
      name: "number"

  requiredAttributes: ["awake_at", "outofbed_at"]
  optionalAttributes: ["awake_energy", "outofbed_energy"]


    # naps:
    #   name: "list"
    #   each:
    #     ...


  ##
  # @override
  _initJsonDefaults: (json) ->
    json ||= {}
    requiredDefaults =
      awake_at: undefined
      outofbed_at: undefined
    # assuming json has no other fields
    # assuming json.best and json.worst are Strings
    # assuming json.funny, json.insight are Strings -- THIS ASSUMPTION
    #   is NOT true because they default to Null!
    # assuming json is an object
    return $.extend(requiredDefaults, json)
