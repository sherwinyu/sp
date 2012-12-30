Sysys.EditableField = Ember.View.extend
  templateName: 'editable_field'
  tagName: 'span'
  rawValue: ''

  doubleClick: ->
    @set('isEditing', true)
    return false

  focusOut: ->
    @set('isEditing', false)
    @finalize()
    false

  keyUp: (evt) ->
    if evt.keyCode == 13
      @finalize()
    false

  finalize: ->
    if (@validate())
      @set('isEditing', false)

  # validate - a function called before commiting rawInput data to actual data.
  # Any parsing should be done here. Return false if input value is invalid, return true otherwise
  validate: ->
    @set('value', @get('rawValue'))
    true


Sysys.TextField = Ember.TextField.extend
  didInsertElement: ->
    if @get('value') != @get('initialValue')
      @$().val(@get('initialValue'))
    @$().focus()

Sysys.DatePickerField = Sysys.EditableField.extend
  validate: ->
    @set('value', Date.parse(@get('rawValue')))
    true

Sysys.DetailsKeyView = Sysys.EditableField.extend
  # stores the value of the key
  value: (->
    details = @get 'details'
    key = details.keyForIndex @get 'index'
  ).property('index', 'details._keys.@each')

  validate: ->
    details = @get 'details'
    keyName = @get 'value'
    ret = details.renameKey keyName, @get('rawValue')

