Sysys.DetailsView = Ember.View.extend
  templateName: "details"

  keysBinding: "parentView.context._keys"

  keyName: ((key, value) ->
    idx = @get('contentIndex')
    if arguments.length == 1 # getter
      @get('keys').get("#{idx}")
    else # setter
      @get('keys').set("#{idx}", value)
  ).property('keysBinding', 'contentIndex')

  init: ->
    @_super()
