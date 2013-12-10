Humon.DaySummary = Humon.Complex.extend
  addField: (e) ->

  init: (args...) ->
    # make sure that all feels exist
    @set('best.nodeVal._value',  "") unless @get('best').val()
    @set('worst.nodeVal._value',  "") unless @get('best').val()
    @set('funny.nodeVal._value',  "asdf") unless @get('funny').val()
    @set('insight.nodeVal._value',  "asdf") unless @get('insight').val()



Humon.DaySummary.reopenClass
  childMetatemplates:
    best:
      name: "String"
    worst:
      name: "String"
    funny:
      name: "String"
    insight:
      name: "String"
