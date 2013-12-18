Humon.Sleep = Humon.Complex.extend(
  validations: [
    (nodeVal) ->
    ,
    (nodeVal) ->
    ,
    (nodeVal) ->
  ]

  validateSelf: ->
    @ensure "Awake at must be before Out of bed", @get("awake_at") < @get("up_at")
    @_super()
)
Humon.Sleep.reopenClass
  childMetatemplates:
    awake_at:
      name: "time"
    up_at:
      name: "time"
    awake_energy:
      name: "number"
    up_energy:
      name: "number"

  requiredAttributes: ["awake_at", "up_at"]
  optionalAttributes: ["awake_energy", "up_energy"]


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
      up_at: undefined
    # assuming json has no other fields
    # assuming json.best and json.worst are Strings
    # assuming json.funny, json.insight are Strings -- THIS ASSUMPTION
    #   is NOT true because they default to Null!
    # assuming json is an object
    return $.extend(requiredDefaults, json)
