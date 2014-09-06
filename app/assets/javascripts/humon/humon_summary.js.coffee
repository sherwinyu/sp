Humon.Summary = Humon.Complex.extend()

Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: 'text'
    worst:
      name: 'text'
    happiness:
      name: 'number'
    funny:
      name: 'text'
    insight:
      name: 'text'
    meditation:
      name: 'meditation'
    coded:
      name: 'boolean'
    uploaded_photos:
      name: 'boolean'
    anki:
      name: "anki"
    work:
      name: "work"

  requiredAttributes: ['best', 'worst', 'happiness', 'meditation', 'work', 'coded', 'uploaded_photos', 'anki']
  optionalAttributes: ['funny', 'insight']

Humon.Summary._generateAccessors()

Humon.Meditation = Humon.Complex.extend()
Humon.Meditation.reopenClass
  childMetatemplates:
    activities:
      name: "text"
    satisfaction:
      name: "number"
  requiredAttributes: ["activities", "satisfaction"]

Humon.Work = Humon.Complex.extend()
Humon.Work.reopenClass
  childMetatemplates:
    arrived_at:
      name: "time"
    left_at:
      name: "time"
  requiredAttributes: ['arrived_at', 'left_at']

Humon.Anki = Humon.Complex.extend()
Humon.Anki.reopenClass
  childMetatemplates:
    new_cards:
      name: 'list'
    time_spent:
      name: 'number'

  requiredAttributes: ['new_cards', 'time_spent']
