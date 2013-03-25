Sysys.ContentField = Ember.TextArea.extend
  rawValueBinding: null
  # value: ''
  border: "5px red solid"
  classNames: ['content-field']
  ###
  contentIndexChanged: (->
    debugger
    unless @get('rawValue')
      @set('value', @get('parentView.content'))
  ).observes('parentView.contentIndex')
      ###


  focusIn: (e)->
    @get('controller').activateNode @get('parentView.content')
    e.stopPropagation()

  focusOut: ->
    # TODO(syu): silent commit?

  didInsertElement: ->
    @set('value', @get('rawValue')) if @get('rawValue')?

    @$().autogrow()

    parentView = @get('parentView')

    @$().bind 'keyup', 'esc',(e) =>
      @get('controller').cancelChanges()
      e.preventDefault()

    @$().bind 'keydown', 'shift+return', (e) =>
      @get('controller').commitAndContinue()
      e.preventDefault()

    @$().bind 'keyup', 'down', (e) =>
      @get('controller').nextNode()

    @$().bind 'keyup', 'up', (e) =>
      @get('controller').prevNode()

  willDestroyElement: ->
    @$().trigger 'remove.autogrow'
