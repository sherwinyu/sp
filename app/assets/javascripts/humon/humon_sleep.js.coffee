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
