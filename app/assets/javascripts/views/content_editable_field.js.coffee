Sysys.ContentEditableField = Ember.View.extend
  tagName: "span"

  rawValueBinding: null
  classNames: ['content-field']
  classNameBindings: ['dirty:dirty:clean', 'autogrowing']
  placeholder: ''

  contenteditable: 'true'
  attributeBindings: ["contenteditable:contenteditable"]

  val: (args...) ->
    @$().html.apply(@$(), args)

  contentLength: ->
    unescape(@val()).length

  # click -- responds to click event on the contentField
  # This exists to prevent propagation to HNV.click, which
  # calls smartFocus
  # TODO(syu): confirm that without CF.click stopping propagation,
  #            HNV.click is called when clicking to gain CF focus.
  #   1) calls stoppropagation
  click: (e) ->
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
    # console.log "focusingIn content editable field", @$()
    true

  # focusOut -- responds to focus out event on the contentField
  # In context: this focusOut bubbles to HNV, which triggers commitEverything
  # can be overridden by subclasses
  #   1) removes the autogrow on the field
  #   2) bubbles the event
  focusOut: (e, options)->
    # console.log "focusingOut content editable field", @$()
    true

  didInsertElement: ->
    @refresh()
    @initHotKeys()

  refresh: ->
    @val @get('rawValue')

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

Sysys.AbstractEditableLabel = Sysys.ContentEditableField.extend
  classNames: ['label-field']
  enter: ->
    if @get('controller.activeHumonNode.isCollection')
      @get('controller').send('insertChild')
    else
      @commitAndContinue()

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'right', (e) =>
      @moveRight(e)

  keyDown: (e) ->
    if e.which ==  186 # colon
      e.preventDefault()
      @get('parentView').moveRight()

  moveRight: (e)->
    if getCursor(@$()) ==  @contentLength()
      @get('parentView').moveRight()
      e.preventDefault()

Sysys.KeyEditableField = Sysys.AbstractEditableLabel.extend
  classNames: ['key-field']
  placeholder: 'key'

  click: (e) ->
    # @get('controller').send 'focusIn'
    console.log "debugger"
    e.stopPropagation()

Sysys.ValEditableField = Sysys.ContentEditableField.extend
  classNames: ['val-field']

  commit: ->
    @get('controller').send('commit', @get 'value')

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft(e)
    # this is necessary to focus the label field properly
    # when a type change occurs and HNV is rerendered and HNV is rerendered
    @$().bind 'keydown', 'shift+tab', (e) =>
      @set 'parentView._focusedField', 'label'

  moveLeft: (e)->
    if getCursor(@$()) ==  0
      @get('parentView').moveLeft()
      e.preventDefault()

Sysys.IdxEditableField = Sysys.AbstractEditableLabel.extend
  classNames: ['idx-field']
  contenteditable: 'false'
  refresh: ->
    @val "#{parseInt(@get('rawValue')) + 1}."

  rawValueDidChange: (->
    @refresh()
  ).observes('rawValue')

  didInsertElement: ->
    @_super()
