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
    @set('autogrowing', false)


  didInsertElement: ->
    @refresh()
    @setPlaceHolderText()
    @initHotKeys()

  refresh: ->
    @set 'value', @get('rawValue')
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
    @$().bind 'keyup', 'esc',(e) =>
      e.preventDefault()
      @cancel()

    @$().bind 'keydown', 'ctrl+shift+return', (e) =>
      e.preventDefault()
      @commit()

    @$().bind 'keydown', 'return', (e) =>
      e.preventDefault()
      @enter()

    @$().bind 'keydown', 'down', (e) =>
      ctrl = @get 'controller'
      e.preventDefault()
      @checkAndSave()
      ctrl.nextNode()

    @$().bind 'keydown', 'up', (e) =>
      ctrl = @get 'controller'
      e.preventDefault()
      @checkAndSave()
      ctrl.prevNode()

    @$().bind 'keydown', 'ctrl+up', (e) =>
      e.preventDefault()
      @get('controller').bubbleUp()

    @$().bind 'keydown', 'ctrl+down', (e) =>
      e.preventDefault()
      @get('controller').bubbleDown()

    @$().bind 'keydown', 'ctrl+left', (e) =>
      e.preventDefault()
      @get('controller').outdent()

    @$().bind 'keydown', 'ctrl+right', (e) =>
      e.preventDefault()
      @get('controller').indent()

    @$().bind 'keydown', 'ctrl+backspace', (e) =>
      e.preventDefault()
      @get('controller').deleteActive()

    @$().bind 'keydown', 'ctrl+shift+l', (e) =>
      console.log 'ctrl shift l'
      @get('controller').forceList()

    @$().bind 'keydown', 'ctrl+shift+h', (e) =>
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

    @$().bind 'keydown', 'colon', (e) =>
      debugger
      e.preventDefault()
      @get('controller').focusValField()

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

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft()

  moveLeft: ->
    if getCursor(@$()) ==  0
      @get('controller').focusLabelField()


Sysys.KeyField = Sysys.AbstractLabel.extend
  classNames: ['key-field']
  placeholder: 'key'
  commit: ->
    console.log 'commiting key'
    @get('controller').commitKey()

Sysys.IdxField = Sysys.AbstractLabel.extend
  classNames: ['idx-field']
  refresh: Em.K
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)

Sysys.ProxyField =  Sysys.ContentField.extend
  classNames: ['proxy-field']
  placeholder: ''
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)
  commitAndContinue: ->
    @get('controller').insertChild()

Sysys.AutogrowField = Sysys.ValField.extend
  classNames: ['autogrow-field']
  didInsertElement: ->
    @_super()

  ag: ->
    @$().autogrowplus()

  ng: ->
    5
