Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  value: '(empty)'
  border: "5px red solid"
  classNames: ['content-field']

  focusIn: ->
    console.log 'controller:', @get('controller')
    # @$().autogrow()

  focusOut: ->
    # commit

  # enterEdit: ->
    # @$(


  exitEdit: ->

  commit: ->

  cancel: ->

  didInsertElement: ->
    @set('value', @get('rawValue'))
    @$().autogrow()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'
