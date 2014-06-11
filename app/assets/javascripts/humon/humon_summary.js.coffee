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
    meditation:
      name: "string"

  requiredAttributes: ["best", "worst", "happiness", "meditation"]
  optionalAttributes: ["funny", "insight"]

Humon.Summary._generateAccessors()
