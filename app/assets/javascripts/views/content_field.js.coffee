Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  value: '(empty)'
  border: "5px red solid"
  classNames: ['content-field']

  focusIn: ->
    # @$().autogrow()

  focusOut: ->
    # @$().trigger "remove.autogrow"

  # enterEdit: ->
    # @$(


  exitEdit: ->

  didInsertElement: ->
    @set('value', @get('rawValue'))
    @$().autogrow()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'
