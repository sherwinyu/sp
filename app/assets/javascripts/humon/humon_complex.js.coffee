## sleep example
Humon.Complex = Humon.Hash.extend(
  isComplex: true

  required: [...]
  requiredAttributes: (->
    for own k, v of requiredAttrs
      attributekey: k
      attributeVal: @get(k)
  ).property()

  required:
    "startedAt": Humon.Time.metaTemplate
    "endedAt": Humon.Time.metaTemplate
    "details": Humon.MetaTemplate.create( ... )
  startedAtBinding: 'children.0'
  endedAtBinding: 'children.1'
  detailsBinding: 'children.2'

)
Humon.Complex.reopenClass(
)
