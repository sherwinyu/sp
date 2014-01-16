Sysys.DataPoint = DS.Model.extend
  submittedAt: Sysys.attr('date')
  startedAt: Sysys.attr('date',
    defaultValue: (-> new Date())
  )
  endedAt: Sysys.attr('date')
  details: Sysys.attr(undefined,
    defaultValue: (->
      mental:
        focus: ""
        happiness: ""
      physical:
        back_pain:
          sacral: ["", "", ""]
          lumbar: ["", "", ""]
          thoracic: ["", "", ""]
          cervical: ["", "", ""]
          notes: ""
    )
  )
  typeMap:
    startedAt:
      name: "time"
    endedAt:
      name: "time"
