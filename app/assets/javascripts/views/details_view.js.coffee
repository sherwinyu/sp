Sysys.DetailsView = Ember.View.extend
  templateName: "details"
  tagName: "span"

  keysBinding: "parentView.context._keys"

  keyName: (key, value) ->
    details = @get('context')
    idx = @get('contentIndex')
    if arguments.length == 1 # getter
      #details.getKeyByVal(
      @get('keys').get("#{idx}")
    else # setter
      @get('keys').set("#{idx}", value)
    


  keyNameForEnumObjects: ((key, value) ->
    idx = @get('contentIndex')
    if arguments.length == 1 # getter
      @get('keys').get("#{idx}")
    else # setter
      @get('keys').set("#{idx}", value)
  ).property('keysBinding', 'contentIndex')

  init: ->
    @_super()

Sysys.KeyField = Sysys.EditableField.extend
  keysBinding: "parentViewj
  

