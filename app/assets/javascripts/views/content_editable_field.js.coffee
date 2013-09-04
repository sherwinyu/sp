Sysys.ContentEditableField = Ember.View.extend
  rawValueBinding: null
  classNames: ['content-field']
  classNameBindings: ['dirty:dirty:clean', 'autogrowing']
  placeholder: ''

  # click -- responds to click event on the contentField
  # This exists to prevent propagation to HNV.click, which
  # calls smartFocus
  # TODO(syu): confirm that without CF.click stopping propagation,
  #            HNV.click is called when clicking to gain CF focus.
  #   1) calls stoppropagation
  click: (e) ->
    console.log 'cf#click propagation stopped'
    e.stopPropagation()

  # focusIn -- responds to focus event on the contentField
  # We don't do any foucs cancelling here; instead we handle it at the HNV level.
  # This means that all 'focus' events are 'real -- if this function
  # is called, this content field WILL become focused.
  #
  # Can be overridden by subclasses
  #   1) calls @autogrow
  #   2) bubbles the event
  focusIn: (e, args...) ->
    console.log "focusingIn content editable field", @$()
    true

  # focusOut -- responds to focus out event on the contentField
  # In context: this focusOut bubbles to HNV, which triggers commitEverything
  # can be overridden by subclasses
  #   1) removes the autogrow on the field
  #   2) bubbles the event
  focusOut: (e, options)->
    console.log "focusingOut content editable field", @$()
    true

  didInsertElement: ->
    @refresh()
    @setPlaceHolderText()
    @initHotKeys()

  refresh: ->
    @set 'value', @get('rawValue')

  setPlaceHolderText: ->
    @$().attr('placeholder', @get('placeholder'))

  commit: Em.K

  # is this an event?
  enter: ->
    @commitAndContinue()

  commitAndContinue: ->
    @get('parentView').commitAndContinue()

  cancel: ->
    @refresh()

  initHotKeys: ->
    @createHotKeys()
    for own combo, func of @get 'hotkeys'
      @$().bind 'keydown', combo, func

  createHotKeys: ->
    @set 'hotkeys',
      'esc': (e) =>
        e.preventDefault()
        @cancel()
      'ctrl+shift+return': (e) =>
        e.preventDefault()
        @commit()
      'return': (e) =>
        e.preventDefault()
        @enter()
      'down': (e) =>
        e.preventDefault()
        @get('parentView').down()
      'up': (e) =>
        e.preventDefault()
        @get('parentView').up()
      'ctrl+up': (e) =>
        e.preventDefault()
        @get('controller').send('bubbleUp')
      'ctrl+down': (e) =>
        e.preventDefault()
        @get('controller').send('bubbleDown')
      'ctrl+left': (e) =>
        e.preventDefault()
        @get('controller').send('outdent')
      'ctrl+right': (e) =>
        e.preventDefault()
        @get('controller').send('indent')
      'ctrl+backspace': (e) =>
        e.preventDefault()
        @get('controller').send('deleteActive')
      'ctrl+shift+l': (e) =>
        console.log 'ctrl shift l'
        @get('controller').send('forceList')
      'ctrl+shift+h': (e) =>
        console.log 'ctrl+shift+h'
        @get('controller').send('forceHash')

Sysys.KeyEditableField = Sysys.ContentEditableField.extend
  classNames: ['content-field', 'key-field']
  contenteditable: 'true'
  attributeBindings: ["contenteditable:contenteditable"]
  placeholder: 'key'
  commit: ->
    @get('controller').commitKey()
  didInsertElement: ->
    @_super()
    @$().html @get('rawValue')
  click: (e)->
    # @get('controller').send 'focusIn'
    console.log "debugger"
    e.stopPropagation()


  focusIn: (e, args...) ->
    console.log "focusingIn keyField", @$()
    true

  focusOut: (e) ->
    console.log "focusOut"

  blur: (e) ->
    console.log "blur"

  activate: (e) ->
    console.log "activate"
