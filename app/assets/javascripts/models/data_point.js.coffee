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
      readOnly: @get('type') == 'LastFmDp'
    at:
      name: "time"
      readOnly: @get('type') == 'LastFmDp'
    endedAt:
      name: "time"
      readOnly: @get('type') == 'LastFmDp'
    details:
      readOnly: @get('type') == 'LastFmDp'
  ).property().volatile()
