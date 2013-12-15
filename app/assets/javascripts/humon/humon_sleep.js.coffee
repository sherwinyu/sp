Humon.Sleep = Humon.Complex.extend(
)
Humon.Sleep.reopenClass
  childMetatemplates:
    awake_at:
      name: "Time"
    outofbed_at:
      name: "Time"
    awake_energy:
      name: "Number"
    outofbed_energy:
      name: "Number"

  requiredAttributes: ["awake_at", "outofbed_at"]
  optionalAttributes: ["awake_energy", "outofbed_energy"]

    # naps:
    #   name: "list"
    #   each:
    #     ...
