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
      name: "meditation"

  requiredAttributes: ["best", "worst", "happiness", "meditation"]
  optionalAttributes: ["funny", "insight"]

Humon.Summary._generateAccessors()

Humon.Meditation = Humon.Complex.extend()
Humon.Meditation.reopenClass
  childMetatemplates:
    activities:
      name: "text"
    satisfaction:
      name: "number"
  requiredAttributes: ["activities", "satisfaction"]

