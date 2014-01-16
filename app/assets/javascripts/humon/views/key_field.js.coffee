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

  moveRight: (e) ->
    if getCursor(@$()) ==  @contentLength()
      @get('parentView').send 'moveRight'
      e.preventDefault()

Sysys.KeyEditableField = Sysys.AbstractEditableLabel.extend
  classNames: ['key-field']
  click: (e) ->
    e.stopPropagation()

##
# This view is usually for the top-level attribute of an object
# It's styled differently:
#   - it shouldn't be contenteditable!
Sysys.KeyFixedField = Sysys.KeyEditableField.extend
  classNames: ['key-field-fixed']
  contenteditable: "false"
