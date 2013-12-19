Humon.Summary = Humon.Complex.extend()

Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: "text"
    worst:
      name: "text"
    funny:
      name: "text"
    insight:
      name: "text"

  requiredAttributes: ["best", "worst"]
  optionalAttributes: ["funny", "insight"]

Humon.Summary._generateAccessors()
