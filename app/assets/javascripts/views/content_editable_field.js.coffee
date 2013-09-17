Sysys.ContentEditableField = Ember.View.extend
  tagName: "span"
  rawValueBinding: null
  classNames: ['content-field']
  classNameBindings: ['dirty:dirty:clean', 'autogrowing']
  contenteditable: 'true'
  tabindex: '0'
  attributeBindings: ["contenteditable:contenteditable",  'tabindex:tabindex']

  val: (args...) ->
    @$().text.apply(@$(), args)

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
    true

  # focusOut -- responds to focus out event on the contentField
  # In context: this focusOut bubbles to HNV, which triggers commitEverything
  # can be overridden by subclasses
  #   1) removes the autogrow on the field
  #   2) bubbles the event
  focusOut: (e, options)->
    true

  didInsertElement: ->
    @refresh()
    @initHotKeys()

  refresh: ->
    @val @get('rawValue')

  # is this an event?
  enter: ->
    @get('parentView').send 'enterPressed'

  cancel: ->
    @refresh()

  initHotKeys: ->
    @createHotKeys()
    for own combo, func of @get 'hotkeys'
      @$().bind 'keydown', combo, func

  createHotKeys: ->
    @set 'hotkeys',
      'return': (e) =>
        e.preventDefault()
        @enter()
      'down': (e) =>
        e.preventDefault()
        @get('parentView').send 'down', e
      'up': (e) =>
        e.preventDefault()
        @get('parentView').send 'up', e
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

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'right', (e) =>
      @moveRight(e)

  keyDown: (e) ->
    if e.which ==  186 # colon
      e.preventDefault()
      @get('parentView').send 'moveRight'

  moveRight: (e)->
    if getCursor(@$()) ==  @contentLength()
      @get('parentView').send 'moveRight'
      e.preventDefault()

Sysys.KeyEditableField = Sysys.AbstractEditableLabel.extend
  classNames: ['key-field']

  click: (e) ->
    e.stopPropagation()

Sysys.ValEditableField = Sysys.ContentEditableField.extend
  classNames: ['val-field']

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
      @get('parentView').send 'moveLeft'
      e.preventDefault()

  rawValueDidChange: (->
    @refresh()
  ).observes('rawValue')

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

Sysys.KeyFixedField = Sysys.KeyEditableField.extend
  classNames: ['key-field-fixed']
  contenteditable: "true"
