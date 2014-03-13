Humon.Summary = Humon.Complex.extend()

Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: "text"
    worst:
      name: "text"
    happiness:
      name: "number"
    funny:
      name: "text"
    insight:
      name: "text"

  requiredAttributes: ["best", "worst", "happiness"]
  optionalAttributes: ["funny", "insight"]

Humon.Summary._generateAccessors()
