Sysys.EditableField = Ember.View.extend
  templateName: 'editable_field'
  tagName: 'span'

  doubleClick: ->
    console.log 'zorgr'
    @set('isEditing', true)
    return false

  focusOut: ->
    @set('isEditing', false)

Sysys.TextField = Ember.TextField.extend
  didInsertElement: ->
    @$().focus()
   
