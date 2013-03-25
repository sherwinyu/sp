Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  # value: ''
  border: "5px red solid"
  classNames: ['content-field']

  focusIn: (e)->
    @get('controller').activateNode @get('parentView.content')
    e.stopPropagation()

  focusOut: ->
    # TODO(syu): silent commit?

  didInsertElement: ->
    # @set('value', @get('rawValue')) if @get('rawValue')?
    @refresh()
    @initHotKeys()
    @$().autogrow()

  refresh: ->
    @set 'value', @get('rawValue')
  commit: Em.K
  commitAndContinue: ->
    @get('controller').commitAndContinue()
    
  cancel: ->
    @refresh()

  initHotKeys: ->
    @$().bind 'keyup', 'esc',(e) =>
      e.preventDefault()
      @cancel()

    @$().bind 'keydown', 'return', (e) =>
      e.preventDefault()
      @commitAndContinue()

    @$().bind 'keydown', 'down', (e) =>
      e.preventDefault()
      @get('controller').nextNode()

    @$().bind 'keydown', 'up', (e) =>
      e.preventDefault()
      @get('controller').prevNode()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  placeholder: 'val'
  commit: ->
    @get('controller').commitVal()
  
Sysys.KeyField = Sysys.ContentField.extend
  classNames: ['key-field']
  placeholder: 'key'
  commit: ->
    @get('controller').commitKey()

Sysys.IdxField = Sysys.ContentField.extend
  classNames: ['idx-field']
  refresh: Em.K
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)

Sysys.ProxyField =  Sysys.ContentField.extend
  classNames: ['proxy-field']
  placeholder: ''
  focusIn: (e)->
    @get('controller').activateNode @get('parentView.content'), focus: true
  didInsertElement: ->
    @_super()
    @$().attr('tabindex', -1)
