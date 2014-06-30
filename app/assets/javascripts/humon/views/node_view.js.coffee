Humon.NodeView = Ember.View.extend
  tagName: "node"
  # readOnly: passed to KeyField and ValFields (inside node_type.emblem templates)
  # readOnlyBinding: "nodeContent.readOnly"

  _templateChanged: false
  _id: null
  _templateStringsEnabled: true
  clearTemplateStrings: -> @set('_templateStringsEnabled', false)
  enableTemplateStrings: -> @set('_templateStringsEnabled', true)
  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent') && @get('nodeContent')?
  ).property('controller.activeHumonNode', 'nodeContent')
  parentActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent.nodeParent')
  ).property('controller.activeHumonNode', 'nodeContent.nodeParent')
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  activateBoundNode: (activate = true) ->
    arg = if activate then @get('nodeContent') else null
    @get('controller').send('activateNode', arg)

  layoutName: "layouts/node_editable_key"
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.nodeType',
    'isActive:active',
    'nodeContent.invalid:invalid',
    'parentActive:activeChild',
    'inline'
  ]
  classNames: ['node', 'line-item-selectable']

#########################
## Dynamic templates
#########################
  ##
  # AutoTemplate is responsible solely for producing the correct template name
  templateNameBinding: "autoTemplate"
  _templateContext: ->
    Humon.templateContextFor(@get 'nodeContent')
  autoTemplate: (->
     @_templateContext().get('templateName')
  ).property('nodeContent.nodeType')
  templateStrings: (->
    Ember.run.sync()
    node = @get('nodeContent')


    if node.get('initialized') && @get('_templateStringsEnabled')
      @_templateContext().materializeTemplateStrings(node)
  ).property('nodeContent.nodeVal', '_templateStringsEnabled')
  templateNameDidChange: (-> @set('_templateChanged', true)).observes('templateName')

  updateId: (-> @set '_id', @$().attr('id')).on 'didInsertElement'
  bindNodeView:   (-> @get('nodeContent')?.set 'nodeView', @).on 'didInsertElement'
  unbindNodeView: (-> @get('nodeContent')?.set 'nodeView', null).on 'willDestroyElement'

#########################
## Actions start
#########################
  actions:
    deletePressed: (e) ->
      @get('controller').send('deletePressed', e, @get('nodeContent'))
      nextNode = @get('nodeContent').prevNode()
      Ember.run =>
        @get('nodeContent.nodeParent')?.deleteChild(@get('nodeContent'))
      if nodeView = nextNode?.get('nodeView')
        nodeView.smartFocus()

    enterPressed: (e) ->
      uiPayload = @uiPayload()
      @get('controller').send('enterPressed', e,  @get('nodeContent'), uiPayload)

    moveLeft: ->
      # You can't focus left on a list!
      if @get('nodeContent.nodeParent.nodeType') is 'list'
        return
      if @get('layoutName') isnt 'layouts/node_editable_key'
        return
      @focusField
        field: 'label'
        pos: 'right'

    moveRight: ->
      @focusField
        field: 'val'
        pos: 'left'

    up:  (e)->
      @get('controller').send 'upPressed', e

    down: (e)->
      @get('controller').send 'downPressed', e

#########################################
## Focus management
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

  ##
  # FocusIn
  # Focus in handles bubbled focusIn events.
  # It calls the controller handleFocusIn hook.
  # Besides, that it activates this node if it isn't already.
  focusIn: (e) ->
    e.stopPropagation()
    # hook for HEC to sendAction focusGained
    @get('controller').send 'handleFocusIn'
    return if @get 'isActive'
    @activateBoundNode()

  ##
  # Focus out handles bubbled focusOut events.
  #  - First calls controller.handleFocusOut to notify the componet we've focusedout.
  #  - Sets activeNode to null
  #  - Constructs a payload with key and val fields, passes it to
  #   nodeVal.subFieldFocusLost
  #  - scheudles a potential rerender
  focusOut: (e) ->
    e.stopPropagation()
    # Even though controllerMixin doesn't have a handleFocusOut method,
    # HumonEditorComponent implements it.
    @get('controller').send 'handleFocusOut'
    @activateBoundNode(no)

    payload = @uiPayload()
    @get('nodeContent.nodeVal').subFieldFocusLost(e, payload)

    # Prepare to rerender if
    #   1) the template has changed
    #   2) This node will no longer be in focus
    # Note that we need to wrap this under Ember.run.scheduleOnce
    # because _templateChanged won't have propagated
    Ember.run.scheduleOnce "afterRender", @, ->
      lostFocus = not @$().has(e.relatedTarget).length
      if @get('_templateChanged') && lostFocus
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
    hasKeys = @keyField()? && (@keyField().get('contenteditable') == "true")
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


  ##
  # Responds to clicks.click -- responds to a click event on the HNV
  # If HNV isn't already active, activate it and smart focus.
  click: (e)->
    e.stopPropagation()
    @activateBoundNode() unless @get('isActive')
    @smartFocus()


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

  flashWarn: (text) ->
    unless @get('warningElement')
      @set('warningElement', text)
      $el = $("<span class='node-type-warning'></span>").text(text)
      $el.appendTo(@$())
      @set('warningElement', $el)
      utils.delayed 1000, ( =>
        $(@get('warningElement')).remove()
        @set('warningElement', null)
        )
