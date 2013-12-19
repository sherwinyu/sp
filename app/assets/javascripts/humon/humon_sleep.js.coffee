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

Humon.Sleep._generateAccessors()
