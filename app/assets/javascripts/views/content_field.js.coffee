Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  classNames: ['content-field']
  placeholder: ''
  autogrowing: false

  click: (e)->
    e.stopPropagation()

  focusIn: (e)->
    @get('controller').activateNode @get('parentView.content')

    unless @get('autogrowing')
      @autogrow()
    e.stopPropagation()

  focusOut: (e)->
    if @get('autogrowing')
      @removeAutogrow()

  autogrow: ->
    @$().autogrowplus horizontal: true, vertical: false
    @set('autogrowing', true)
  removeAutogrow: ->
    @$().trigger 'remove.autogrowplus'
    console.log 'removing autogrow'
    @set('autogrowing', false)

  didInsertElement: ->
    @refresh()
    @autosize()
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
    @get('controller').commitAndContinue()

  cancel: ->
    @refresh()

  initHotKeys: ->
    @createHotKeys()
    for own combo, func of @get 'hotkeys'
      @$().bind 'keydown', combo, func

  createHotKeys: ->
    @set 'hotkeys',
      'ctrl+shift+return': (e) =>
        e.preventDefault()

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
        ctrl = @get 'controller'
        e.preventDefault()
        @checkAndSave()
        ctrl.nextNode()

      'up': (e) =>
        ctrl = @get 'controller'
        e.preventDefault()
        @checkAndSave()
        ctrl.prevNode()

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

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'

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
      @moveRight()

  keyDown: (e) ->
    if e.which ==  186 # colon
      e.preventDefault()
      @get('controller').focusValField()

  moveRight: ->
    if getCursor(@$()) ==  @$().val().length
      @get('controller').focusValField()

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  placeholder: 'val'
  commit: ->
    @get('controller').commit()
  focusOut: ->
    @_super()
    @checkAndSave()

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft()

  moveLeft: ->
    if getCursor(@$()) ==  0
      @get('controller').focusLabelField()

Sysys.BigValField = Sysys.ValField.extend
  classNames: ['big-val-field']
  autogrow: ->
    @$().autogrowplus horizontal: true, vertical: true
  focusOut: (e)->
    @_super(e)
    @get('parentView').exitEditing()
  cancel: ->
    @removeAutogrow()
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
    @get('parentView').enterEditing()

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


