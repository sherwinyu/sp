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
    uploaded_photos:
      name: 'boolean'
    anki:
      name: 'anki'
    work:
      name: 'work'

    coded:
      name: 'boolean'
    coded_in_am:
      name: 'boolean'
    mindfulness:
      name: 'boolean'
    in_bed_by_1130:
      name: 'boolean'
    chns_sentence:
      name: 'boolean'

  requiredAttributes: ['best'
                       'worst'
                       'happiness'
                       'meditation'
                       'work'
                       'uploaded_photos'
                       'anki'
                       'coded'
                       'coded_in_am'
                       'mindfulness'
                       'in_bed_by_1130'
                       'chns_sentence'
                      ]

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
