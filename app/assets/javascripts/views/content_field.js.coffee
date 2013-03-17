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


  didInsertElement: ->
    @set('value', @get('rawValue'))

    @$().autogrow()

    parentView = @get('parentView')

    @$().bind 'keyup', 'esc', =>
      console.log 'gajump'
      parentView.cancel()

    @$().bind 'keydown', 'shift+return', (e) =>
      parentView.commit()
      e.preventDefault()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'
