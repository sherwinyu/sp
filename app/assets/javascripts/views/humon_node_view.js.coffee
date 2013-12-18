Sysys.HumonNodeView = Ember.View.extend
  _templateChanged: false
  _id: null
  _templateStringsEnabled: true

  layoutName: "humon_node_key_layout"
  # TODO(syu) #RANSIT
  templateStrings: (->
    Ember.run.sync()
    node = @get('nodeContent')
    unless node.get('notInitialized') or !@get('_templateStringsEnabled')
      templateContext = Humon.templateContextFor(node)
      templateContext.materializeTemplateStrings(node)
    else
      {}
  ).property('nodeContent.nodeVal', '_templateStringsEnabled')

  clearTemplateStrings: ->
    @set('_templateStringsEnabled', false)
  enableTemplateStrings: ->
    @set('_templateStringsEnabled', true)


  # autoTemplate is responsible solely for producing the correct template name
  autoTemplate: (->
    Ember.run.sync()
    node = @get('nodeContent')
    templateContext = Humon.templateContextFor(@get 'nodeContent')
    templateContext.get('templateName')
  ).property('nodeContent.nodeType')
  templateNameDidChange: (->
    @set('_templateChanged', true)
  ).observes('templateName')
  templateNameBinding: "autoTemplate"
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.nodeType',
    'isActive:active',
    'nodeContent.invalid:invalid',
    'parentActive:activeChild']
  classNames: ['node']

  updateId: (-> @set '_id', @$().attr('id')).on 'didInsertElement'
  bindNodeView:   (-> @get('nodeContent')?.set 'nodeView', @).on 'didInsertElement'
  unbindNodeView: (-> @get('nodeContent')?.set 'nodeView', null).on 'willDestroyElement'

  actions:

    # Default: validate and commit
    enterPressed: ->
      return unless @get('nodeContent.nodeVal').enterPressed()

      payload = @uiPayload()
      @get('nodeContent').tryToCommit( payload )
      Ember.run.scheduleOnce "afterRender", @, ->
        if @get('_templateChanged')
          # Make sure we clear templateChanged after a rerender.
          @set('_templateChanged', false)
          @rerender()
          Ember.run.later => @smartFocus()

    moveLeft: ->
      # you can't focus left on a list!
      if @get('nodeContent.nodeParent.nodeType') is 'list'
        return
      if @get('layoutName') is 'humon_node_fixed_key_layout'
        return
      @focusField
        field: 'label'
        pos: 'right'

    moveRight: ->
      @focusField
        field: 'val'
        pos: 'left'

    # up -- handles the event of moving to the previous node
    # Context: TODO(syu)
    #   1) calls prevNode on the controller
    #   2) if prevNode was successful (returns a new node), then send smartFocus to controller
    up:  (e)->
      if @get('controller').prevNode(e)
        Ember.run.sync()
        @get('controller').send 'smartFocus'

    down: (e)->
      if changed = @get('controller').nextNode(e)
        Ember.run.sync()
        @get('controller').send 'smartFocus'

#########################################
## End actions
########################################

  ##
  # Prepares a payload from the valfields
  # @return [JSON] payload
  #   - key [string]
  #   - val [string]
  uiPayload: ->
    payload =
      key: @keyField()?.val()
      val: @valField()?.val()

  # focusIn
  #  1) cancels propagation
  #  2) if current HNV is active returns and does nothing
  #     if current HNV is not active,  calls activateNode on the current node content
  #
  #  This is primarily called indirectly by event bubbling from content fields
  focusIn: (e) ->
    e.stopPropagation()
    # hook for HEC to sendAction focusGained
    @get('controller').handleFocusIn()
    return if @get 'isActive'
    @get('controller').send('activateNode', @get('nodeContent'))


  ##
  # New focus out.
  #  - First calls controller.handleFocusOut to notify the componet we've focusedout.
  #  - Sets activeNode to null
  #  - Constructs a payload with key and val fields, passes it to
  #   nodeVal.subFieldFocusLost
  #  - scheudles a potential rerender
  focusOut: (e) ->
    e.stopPropagation()

    # Even though controllerMixin doesn't have a handleFocusOut method,
    # HumonEditorComponent implements it.
    @get('controller').handleFocusOut()

    @get('controller').send('activateNode', null)
    payload = @uiPayload()
    @get('nodeContent.nodeVal').subFieldFocusLost(e, payload)

    # Prepare to rerender if
    #   1) the template has changed
    #   2) This node will no longer be in focus
    # Note that we need to wrap this under Ember.run.scheduleOnce
    # because _templateChanged won't have propagated
    Ember.run.scheduleOnce "afterRender", @, ->
      if @get('_templateChanged') && not @$().has(e.relatedTarget).length
        # Make sure we clear templateChanged after a rerender.
        @set('_templateChanged', false)
        @rerender()

  ##
  # smartFocus -- "auto" sets the focus for this HNV based on context
  # Triggers the 'focus' event on the DOM element corresponding to a
  # child contentField. The focus event is handled by CF.focusIn, which
  # bubbles it to HNV.focusIn, which can conditioanlly do stuff, such as
  # trigger activateNode
  #
  # contexts used
  #   * Key field empty?
  #   * Val field empty?
  #   * context?
  #   TODO(syu): refactor to use semantic variables
  #     e.g., keyFieldPresent, valFieldPresent, idxFieldPresent
  smartFocus: ->
    node = @get('nodeContent')
    hasKeys = node.get('nodeParent.hasKeys')
    nodeKey = node.get('nodeKey')
    nodeVal = @valField()?.val()
    isLiteral = node.get('isLiteral')
    isCollection = node.get('isCollection')
    opts = {}

    # the labelfield is key AND a key is present AND valfield is present
    if hasKeys && isLiteral && nodeKey && !nodeVal
      opts.field = 'label'
    # the labelfield is key AND the key is empty
    else if hasKeys && !nodeKey
      opts.field = 'label'
    # the labelfield is key AND no val field is present
    else if hasKeys && isCollection
      opts.field = 'label'
    # the labelfield is list AND no val field present
    else if !hasKeys && isCollection
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

  ##
  # Helper methods to fetch the Ember.View objects of the corresponding child fields
  # NOTE this gets the FIRST instance of child field of this type
  labelField: ->
    @get("childViews").find (view) -> view instanceof Sysys.AbstractEditableLabel
  keyField: ->
    @get("childViews").find (view) -> view instanceof Sysys.KeyEditableField
  idxField: ->
    @get("childViews").find (view) -> view instanceof Sysys.IdxEditableField
  valField: ->
    @get("childViews").find (view) -> view instanceof Sysys.ValEditableField

  ##
  # Tries to manipulate the focus (either via setCursor or $().focus()) to a child field of this
  # humon node view.
  # Note:
  # @param [JSON] opts a JSON object with the following properties
  #   - field [string]
  #   - pos [string] either "left" or "right"
  #
  # TODO(syu): Decide on how to handle the case of the keyfixedfield.
  #   Should the key be editable? Currently it's not (content editable is false)
  #   but it still extends from ContentEditableField.
  #   It should probably still stay focusable though.
  focusField: (opts) ->
    Em.assert "opts to FocusField must be POJO", typeof opts is "object"
    fieldView = @["#{opts.field}Field"]()
    # console.log "focusing field, field: #{opts.field}, pos: #{opts.pos}, opts: #{JSON.stringify opts} fieldView: ", fieldView.$()

    # This is ASSUMING that anything we would ever want to focus on is a subclass of
    # Sysys.ContentEditableField
    if fieldView instanceof Sysys.ContentEditableField
      # We explicitly call .focus() because setCursor won't work for noncontenteditable fields
      #  Example: when KeyFixedField
      fieldView.$().focus()
      setCursor(fieldView.$().get(0), fieldView.contentLength())
    else
      # It's possible that this field doesn't exist:
      # "moveRight" on a node-collection's label field
      # no val field exists!
      return

    # for some reason, fieldView can suddenly be updated by the call
    # to `setCursor`. If this happens, we need to regrab the fieldView
    if fieldView.state isnt "inDom"
      fieldView = @["#{opts.field}Field"]()
    Em.assert "fieldView must be inDOM", fieldView.state is "inDOM"
    if opts.pos == "left"
      setCursor(fieldView.$().get(0), 0)
    if opts.pos == "right"
      setCursor(fieldView.$().get(0), fieldView.contentLength())
    return
