Sysys.DataPoint = DS.Model.extend
  type: Sysys.attr 'string'
  at: Sysys.attr('date',
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
  typeMap: (->
    type:
      name: "string"
    at:
      name: "time"
    endedAt:
      name: "time"
    details:
      readOnly: @get('type') == 'LastFmDp'
  ).property().volatile()
