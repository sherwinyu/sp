Humon.DaySummary = Humon.Complex.extend
  addField: (e) ->

  init: (args...) ->
    # make sure that all feels exist
    @set('best', Humon.j2n "") unless @get('best').val()
    @set('worst', Humon.j2n "") unless @get('best').val()
    @set('funny', Humon.j2n "asdf") unless @get('funny').val()
    @set('insight', Humon.j2n "asdf") unless @get('insight').val()



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
