Humon.Sleep = Humon.Complex.extend(
)
Humon.Sleep.reopenClass
  childMetatemplates:
    awake_at:
      name: "Date"
    outofbed_at:
      name: "Date"
    awake_energy: "Integer"
    outofbed_energy: "Integer"
    # naps:
    #   name: "list"
    #   each:
    #     ...
