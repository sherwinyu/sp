Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  classNames: ['content-field']
  classNameBindings: ['dirty:dirty:clean', 'autogrowing']
  placeholder: ''
  autogrowing: false

  val: (args...) ->
    @$().val.apply(@$(), args)
  contentLength: ->
    @val().length


  dirty: ( ->
    return false unless @get('state') == 'inDOM'
    ret = @get('rawValue') != @get('value')
    ret
  ).property('rawValue', 'value')

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
    console.log "focusingIn contentfield", @$()
    @autogrow(false)
    true

  # focusOut -- responds to focus out event on the contentField
  # In context: this focusOut bubbles to HNV, which triggers commitEverything
  # can be overridden by subclasses
  #   1) removes the autogrow on the field
  #   2) bubbles the event
  focusOut: (e, options)->
    console.log "focusingOut contentfield", @$()
    @removeAutogrow(false)
    true

  # autogrow -- attempts to add autogrow to the current field
  # @param fail -- specifies failure behavior
  #   true (default) - fail if already autogrowing
  #   false - ignore autogrow check
  # Spec
  #   1) it calls autogrowplus, horizontal true, vertical true
  autogrow: (fail = true)->
    return
    unless @get 'autogrowing'
      #console.log '.... successfully'
      @$().autogrowplus horizontal: true, vertical: true
      @set('autogrowing', true)
    else
      #console.log '.... unsuccessfully'
      Em.assert "#{@$()} shouldn't already be autogrowing" if fail

  # removeAutogrow -- attempts to remove autogrow from the current field
  # @param fail -- specifies failure behavior
  #   true (default) - fail unless already autorowing
  #   false - ignore already autogrowing check
  # Spec
  #   1) it triggers 'remove.autogrowPlus'
  removeAutogrow: (fail = true)->
    return
    if @get 'autogrowing'
      @$().trigger 'remove.autogrowplus'
      @set('autogrowing', false)
      #console.log '   ...successfully'
    else
      #console.log '.... unsuccessfully'
      Em.assert "#{@$()} should already be autogrowing" if fail

  didInsertElement: ->
    @refresh()
    # @autosize()
    @setPlaceHolderText()
    @initHotKeys()

  refresh: ->
    @set 'value', @get('rawValue')

  autosize: ->
    @autogrow()
    @removeAutogrow()

  setPlaceHolderText: ->
    @$().attr('placeholder', @get('placeholder'))

  commit: Em.K

  enter: ->
    @commitAndContinue()

  commitAndContinue: ->
    @get('parentView').commitAndContinue()

  cancel: ->
    @refresh()

  keyDown: (e) ->
    console.log(e)

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

  willDestroyElement: ->
    @removeAutogrow(false)

Sysys.AbstractLabel = Sysys.ContentField.extend
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
    if getCursor(@$()) ==  @$().val().length
      @get('parentView').moveRight()
      e.preventDefault()

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  placeholder: 'val'
  commit: ->
    @get('controller').send('commit', @get 'value')

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft(e)

  moveLeft: (e)->
    if getCursor(@$()) ==  0
      @get('parentView').moveLeft()
      e.preventDefault()

Sysys.KeyField = Sysys.AbstractLabel.extend
  classNames: ['key-field']
  placeholder: 'key'
  commit: ->
    @get('controller').commitKey()

Sysys.IdxField = Sysys.AbstractLabel.extend
  classNames: ['idx-field']
  refresh: Em.K
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)
