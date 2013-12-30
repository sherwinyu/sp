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
    melatonin_at:
      name: "time"
      dayStartsAt: 4
    computer_off_at:
      name: "time"
      dayStartsAt: 4
    lights_out_at:
      name: "time"
      dayStartsAt: 4

    awake_energy:
      name: "number"
    up_energy:
      name: "number"
    computer_off_energy:
      name: "time"
    lights_out_energy:
      name: "time"

  requiredAttributes: ["awake_at", "up_at", "computer_off_at", "melatonin_at", "lights_out_at"]
  optionalAttributes: ["awake_energy", "up_energy", "computer_off_energy", "lights_out_energy"]

Humon.Sleep._generateAccessors()
