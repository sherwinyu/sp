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
    # naps:
    #   name: "list"
    #   each:
    #     ...
