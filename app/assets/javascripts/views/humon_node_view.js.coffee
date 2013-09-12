Sysys.HumonNodeView = Ember.View.extend
  _focusedField: null

  templateStrings: (->
    if @get('nodeContent.isLiteral')
      HumonTypes.contextualize(@get 'nodeContent')._materializeTemplateStringsForNode(@get 'nodeContent')
  ).property('nodeContent.nodeVal')

  # autoTemplate is responsible solely for producing the correct template name
  autoTemplate: (->
    node = @get('nodeContent')
    if @get('nodeContent.isLiteral')
      HumonTypes.contextualize(node).templateName
    else
      "humon_node"
  ).property('nodeContent.nodeType')
  templateNameBinding: "autoTemplate"
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.nodeType',
    'isActive:active',
    'parentActive:activeChild',
    'suppressGap']
  classNames: ['node']

  actions:

    # up -- handles the event of moving to the previous node
    # Context: TODO(syu)
    #   1) calls prevNode on the controller
    #   2) if prevNode was successful (returns a new node), then send smartFocus to controller
    up:  ->
      if @get('controller').prevNode() #send('prevNode')
        @set "_focusedField", null
        Ember.run.sync()
        @get('controller').send 'smartFocus'

    down: ->
      if changed = @get('controller').nextNode() #send('nextNode')
        @set "_focusedField", null
        Ember.run.sync()
        @get('controller').send 'smartFocus'

    enterPressed: ->
      if @get('controller.activeHumonNode.isCollection')
        @get('controller').send('insertChild')
        return
      if @valField()?.val() == ''
        @valField().val '{}'
      payload =
        val: @valField()?.val()
        key: @keyField()?.val()
      if @get('controller.activeHumonNode.nodeParent.isCollection')
        @get('controller').send 'commitAndContinueNew', payload
      else
        @get('controller').send 'commitLiteral', payload

        console.log 'activeNode', @get('controller.activeHumonNode')


    moveLeft: ->
      # you can't focus left on a list!
      if @get('nodeContent.nodeParent.nodeType') is 'list'
        return
      @set '_focusedField',
        field: 'label'
        pos: 'right'
      Ember.run.schedule "afterRender", @, ->
        @focusField @get '_focusedField'

    moveRight: ->
      @set '_focusedField',
        field: 'val'
        pos: 'left'
      @focusField @get '_focusedField'

  # focusIn
  #  1) cancels propagation
  #  2) if current HNV is active returns and does nothing
  #     if current HNV is not active,  calls activateNode on the current node content
  #
  #  This is primarily called indirectly by event bubbling from content fields
  focusIn: (e) ->
    e.stopPropagation()
    if @get 'isActive'
      return
    else
      @get('controller').send('activateNode', @get('nodeContent'))
      # TODO(syu): @get('controller').transitionToNode @get('nodeContent')

  # focusOut -- handle focusOut from a sub-contentField
  # This also means that anytime a sub-contentField focuses out, we commit the entire
  # node as a unit.
  #
  #   1) constructs a payload to be sent to @controller `commitEverything`
  #   2) payload contains {key, val}
  #   3) key is taken from the key field's value
  #   4) val is taken from the val field if the val field is dirty #TODO clarify dirty
  #   5) stops propagation (we don't want parent nodes commiting!)
  focusOut: (e) ->
    e.stopPropagation()
    @get('controller').send('activateNode', null)
    # prepare payload: pull from $().val, etc
    # send to `commitEverything
    node = @get('nodeContent')
    payload =
      key: @keyField()?.val()
      node: node

    # if the value has been modified, include val in the payload
    if @valField()?.val() isnt @get("templateStrings.asString")
      payload.val = @valField()?.val()
    @get('controller').send 'commitEverything', payload

  # smartFocus -- "auto" sets the focus for this HNV based on context
  # Triggers the 'focus' event on the DOM element corresponding to a
  # sub-contentField. The focus event is handled by CF.focusIn, which
  # bubbles it to HNV.focusIn, which can conditioanlly do stuff.
  #
  # contexts used
  #   * Key field empty?
  #   * Val field empty?
  #   * context?
  #   TODO(syu): refactor to use semantic variables
  #     e.g., keyFieldPresent, valFieldPresent, idxFieldPresent
  smartFocus: ->
    node = @get('nodeContent')
    context = node.get('nodeParent.nodeType') || "hash"
    nodeKey = node.get('nodeKey')
    nodeVal = @valField()?.val()
    isLiteral = node.get('isLiteral')
    isCollection = node.get('isCollection')
    opts = {}

    # the labelfield is key AND a key is present AND valfield is present
    if context == 'hash' && isLiteral && nodeKey && !nodeVal
      opts.field = 'label'
    # the labelfield is key AND the key is empty
    else if context == 'hash' && !nodeKey
      opts.field = 'label'
    # the labelfield is key AND no val field is present
    else if context =='hash' && isCollection
      opts.field = 'label'
    # the labelfield is list AND no val field present
    else if context =='list'  && isCollection
      opts.field = 'label'
    else
      opts.field = "val"
      opts.pos = "right"
    @focusField opts

  # click -- responds to a click event on the HNV
  # primarily for
  #   1) cancels propagation
  #   2) if HNV is already active, just smart focus
  #   3) if HNV is not active, set it as active
  #   4) regardless, call @smartFocus
  click: (e)->
    e.stopPropagation()
    unless @get('isActive')
      @get('controller').send('activateNode', @get('nodeContent'))
    @smartFocus()


  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent') && @get('nodeContent')?
  ).property('controller.activeHumonNode', 'nodeContent')

  parentActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent.nodeParent')
  ).property('controller.activeHumonNode', 'nodeContent.nodeParent')

  # normally, there is a 5px gap at the bottom of node-collections to make room for the [ ] and { } glyphs.
  # However, if multiple collections all exit, we don't want a ton of white space, so we only show the gap
  # if this nodeCollection has an additional sibling after it
  suppressGap: (->
    @get('nodeContent.nodeParent.nodeVal.lastObject') == @get('nodeContent')
  ).property('nodeContent.nodeParent.nodeVal.lastObject')

  willDestroyElement: ->
    @get('nodeContent')?.set 'nodeView', null

  didInsertElement: ->
    if @get("_focusedField")
      # needs to be in a deferred because the child views (node fields)
      # might not have had their text set up (via didInsertElement)
      Ember.run.scheduleOnce "afterRender", @, =>
        @focusField(@get("_focusedField"))
        @set "_focusedField", null
    @get('nodeContent')?.set 'nodeView', @

  labelField: ->
    @get("childViews").find (view) -> view instanceof Sysys.AbstractEditableLabel
  keyField: ->
    @get("childViews").find (view) -> view instanceof Sysys.KeyEditableField
  idxField: ->
    @get("childViews").find (view) -> view instanceof Sysys.IdxEditableField #KeyEditableField
  valField: ->
    @get("childViews").find (view) -> view instanceof Sysys.ValEditableField #IdxEditableField#KeyEditableField

  # focusField --
  focusField: (opts) ->
    if typeof opts is "string"
      opts = field: opts
    console.log "focusing field, #{opts.field}, #{opts.pos}"

    # if no field is present
    # this can happen in cases such as
    #   current node is a collection (no val field)
    #   and context is a list (no key field)
    if opts.field == "none"
      $('textarea').blur()
      $('div').blur()
      return

    # get the field view
    fieldView = @["#{opts.field}Field"]()

    if fieldView instanceof Ember.TextArea
      fieldView.$().focus()
    else if fieldView instanceof Sysys.ContentEditableField
      setCursor(fieldView.$().get(0), fieldView.contentLength())
    else
      # it's possible that this field doesn't exist:
      # "moveRight" on a node-collection's label field
      # no val field exists!
      return

    # for some reason, fieldView can suddenly be updated by the call
    # to `setCursor`. If this happens, we need to regrab the fieldView
    if fieldView.staate isnt "inDom"
      fieldView = @["#{opts.field}Field"]()
    Em.assert "fieldView must be inDOM", fieldView.state is "inDOM"
    if opts.pos == "left"
      setCursor(fieldView.$().get(0), 0)
    if opts.pos == "right"
      setCursor(fieldView.$().get(0), fieldView.contentLength())
    return

