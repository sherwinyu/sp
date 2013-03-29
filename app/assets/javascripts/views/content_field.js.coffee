Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  classNames: ['content-field']
  placeholder: ''

  focusIn: (e)->
    @get('controller').activateNode @get('parentView.content')
    e.stopPropagation()

  focusOut: ->
    # TODO(syu): silent commit?

  didInsertElement: ->
    @refresh()
    @setPlaceHolderText()
    @initHotKeys()
    @$().autogrow()

  refresh: ->
    @set 'value', @get('rawValue')
  setPlaceHolderText: ->
    @$().attr('placeholder', @get('placeholder'))
  commit: Em.K
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
      @commitAndContinue()

    @$().bind 'keydown', 'down', (e) =>
      e.preventDefault()
      @get('controller').nextNode()

    @$().bind 'keydown', 'up', (e) =>
      e.preventDefault()
      @get('controller').prevNode()

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
      console.log 'ctrl backspace'
      @get('controller').deleteActive()

    @$().bind 'keydown', 'ctrl+shift+l', (e) =>
      console.log 'ctrl shift l'
      @get('controller').forceList()

    @$().bind 'keydown', 'ctrl+shift+h', (e) =>
      console.log 'ctrl+shift+h'
      @get('controller').forceHash()



  willDestroyElement: ->
    @$().trigger 'remove.autogrow'

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  placeholder: 'val'
  commit: ->
    @get('controller').commitVal()

Sysys.KeyField = Sysys.ContentField.extend
  classNames: ['key-field', 'key']
  placeholder: 'key'
  commit: ->
    console.log 'commiting key'
    @get('controller').commitKey()

Sysys.IdxField = Sysys.ContentField.extend
  classNames: ['idx-field', 'key']
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
