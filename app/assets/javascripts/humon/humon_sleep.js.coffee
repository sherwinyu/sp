Humon.Sleep = Humon.Complex.extend(
)
Humon.Sleep.reopenClass
  childMetatemplates:
    awake_at:
      name: "Date"
    outofbed_at:
      name: "Date"
    awake_energy:
      name: "Number"
    outofbed_energy:
      name: "Number"
    # naps:
    #   name: "list"
    #   each:
    #     ...
