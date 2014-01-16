#= require ./key_field
Sysys.IdxEditableField = Sysys.AbstractEditableLabel.extend
  classNames: ['idx-field']
  contenteditable: 'false'
  tabindex: '0'
  attributeBindings: ['tabindex:tabindex']

  refresh: ->
    @val "#{parseInt(@get('rawValue')) + 1}."
  # Keep the displayed value in sync
  rawValueDidChange: (->
    @refresh()
  ).observes('rawValue')
