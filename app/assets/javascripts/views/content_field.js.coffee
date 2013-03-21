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

    @$().bind 'keyup', 'esc',(e) =>
      @get('controller').cancelChanges()
      e.preventDefault()

    @$().bind 'keydown', 'shift+return', (e) =>
      @get('controller').commitAndContinue()
      e.preventDefault()

    @$().bind 'keyup', 'down', (e) =>
      @get('controller').nextNode()

    @$().bind 'keyup', 'up', (e) =>
      @get('controller').prevNode()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'
