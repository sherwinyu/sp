Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  classNames: ['content-field']
  classNameBindings: ['dirty:dirty:clean', 'autogrowing']
  placeholder: ''
  autogrowing: false

  dirty: ( ->
    return false unless @get('state') == 'inDOM'
    ret = @get('rawValue') != @get('value')
    console.log ret
    ret
  ).property('rawValue', 'value')

  focusIn: (e)->
    console.log "focusingIn contentfield. currently focused item is",  $(':focus')
    @autogrow(false)
    true

    # unless @get('autogrowing')
    # @autogrow()
    # e.stopPropagation()
    # console.log "focusingIn contentfield. currently focused item is",  $(':focus')
    # true

  focusOut: (e)->
    console.log "focusingOut contentfield. currently focused item is",  $(':focus')
    @removeAutogrow(false)
    true

  # attempts to set autogrow to true
  autogrow: (fail = true)->
    console.log 'autogrow called'
    unless @get 'autogrowing'
      console.log '.... successfully'
      @$().autogrowplus horizontal: true, vertical: true
      @set('autogrowing', true)
    else
      console.log '.... unsuccessfully'
      Em.assert "#{@$()} shouldn't already be autogrowing" if fail

  removeAutogrow: (fail = true)->
    console.log 'removeAutogrow called'
    if @get 'autogrowing'
      @$().trigger 'remove.autogrowplus'
      @set('autogrowing', false)
      console.log '   ...successfully'
    else
      console.log '.... unsuccessfully'
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

  checkAndSave: ->
    # TODO(syu) -- convert to string!
    Ember.run =>
      if @get('rawValue') + "" != @$().val()
        @commit()

  commit: Em.K

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
        Em.assert ' not supported yet '
        ctrl = @get 'controller'
        e.preventDefault()
        # @checkAndSave()
        ctrl.send 'nextNode'
      'up': (e) =>
        Em.assert ' not supported yet '
        ctrl = @get 'controller'
        e.preventDefault()
        # @checkAndSave()
        ctrl.send 'prevNode'
      'ctrl+up': (e) =>
        e.preventDefault()
        @get('controller').bubbleUp()
      'ctrl+down': (e) =>
        e.preventDefault()
        @get('controller').bubbleDown()
      'ctrl+left': (e) =>
        e.preventDefault()
        @get('controller').outdent()
      'ctrl+right': (e) =>
        e.preventDefault()
        @get('controller').indent()
      'ctrl+backspace': (e) =>
        e.preventDefault()
        @get('controller').deleteActive()
      'ctrl+shift+l': (e) =>
        console.log 'ctrl shift l'
        @get('controller').forceList()
      'ctrl+shift+h': (e) =>
        console.log 'ctrl+shift+h'
        @get('controller').forceHash()
      'ctrl+space': (e) =>
        @get('parentView').enterEditing()
        e.preventDefault()

  willDestroyElement: ->
    @removeAutogrow(false)

Sysys.AbstractLabel = Sysys.ContentField.extend
  classNames: ['label-field']
  enter: ->
    if @get('controller.activeHumonNode.isCollection')
      @get('controller').insertChild()
    else
      @commitAndContinue()

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'right', (e) =>
      @moveRight(e)

  keyDown: (e) ->
    if e.which ==  186 # colon
      e.preventDefault()
      @get('controller').focusValField()

  moveRight: (e)->
    if getCursor(@$()) ==  @$().val().length
      @get('controller').focusValField()
      e.preventDefault()

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  placeholder: 'val'
  commit: ->
    @get('controller').commit(@get 'value')

    # focusOut: ->
    # @_super()
    # # @checkAndSave()
    # console.log("VAL FIELD LOSING FOCUS #{@$().val()}")
    # true

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft(e)

  moveLeft: (e)->
    if getCursor(@$()) ==  0
      @get('controller').focusLabelField()
      e.preventDefault()

Sysys.BigValField = Sysys.ValField.extend
  classNames: ['big-val-field']
  autogrow: ->
    @$().autogrowplus horizontal: true, vertical: true
  # TODO(syu): merge this with valfield
  focusOut: (e)->
    Em.assert 'not supported yet'
    @get('parentView').exitEditing()
    e.stopPropagation()
  commit: ->
    @get('controller').commitWithRerender @get 'value'
  cancel: ->
    @get('parentView').exitEditing()

  createHotKeys: ->
    @_super()
    hotkeys = @get('hotkeys')
    hotkeys['return'] = Em.K
    hotkeys['up'] = Em.K
    hotkeys['down'] = Em.K
  autosize: Em.K

Sysys.ProxyField = Sysys.ContentField.extend
  classNames: ['proxy-field']

  placeholder: ''
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)
  commitAndContinue: ->
    @get('controller').insertChild()
  focusIn: (e)->
    @_super(e)
    # @get('parentView').enterEditing()
    e.stopPropagation()

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
