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
      @cancel()
      e.preventDefault()

    @$().bind 'keydown', 'return', (e) =>
      @commitAndContinue()
      e.preventDefault()

    @$().bind 'keyup', 'down', (e) =>
      @get('controller').nextNode()

    @$().bind 'keyup', 'up', (e) =>
      @get('controller').prevNode()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'

Sysys.ValField = Sysys.ContentField.extend
  classNames: ['val-field']
  commit: ->
    @get('controller').commitVal()
  
Sysys.KeyField = Sysys.ContentField.extend
  classNames: ['key-field']
  commit: ->
    @get('controller').commitKey()
