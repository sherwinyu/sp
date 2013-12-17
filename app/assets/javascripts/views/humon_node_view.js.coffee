Sysys.HumonNodeView = Ember.View.extend
  _templateChanged: false
  _id: null

  layoutName: "humon_node_key_layout"
  # TODO(syu) #RANSIT
  templateStrings: (->
    Ember.run.sync()
    @get('nodeContent')
    templateContext = Humon.templateContextFor(@get 'nodeContent')
    templateContext.materializeTemplateStrings(@get 'nodeContent')
  ).property('nodeContent.nodeVal')

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
    'parentActive:activeChild',
    'suppressGap']
  classNames: ['node']

  updateId: (->
    @set('_id', @$().attr('id'))
  ).on 'didInsertElement'

  actions:
    addField: (e) ->
      console.log "FIELD ADD"

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

    # Default: validate and commit
    enterPressed: ->
      return unless @get('nodeContent.nodeVal').enterPressed()
      valString = @valField()?.val()
      @get('nodeContent').tryToCommit( valString )
      Ember.run.scheduleOnce "afterRender", @, ->
        if @get('_templateChanged')
          # Make sure we clear templateChanged after a rerender.
          @set('_templateChanged', false)
          @rerender()
          Ember.run.later =>
            @smartFocus()


    oldEnterPressed: ->
      if @get('controller.activeHumonNode.isCollection') && @get('controller.activeHumonNode.acceptsArbitraryChildren')
        @get('controller').send('insertChild')
        return
      if @valField()?.val() == ''
        @valField().val '{}'
      payload =
        val: @valField()?.val()
        key: @keyField()?.val()
      # If current node's parent is a collection most common case)
      # then we send commitAndContinueNew, which will both commit,
      # and insert a child
      if @get('controller.activeHumonNode.nodeParent.isCollection')
        @get('controller').send 'commitAndContinueNew', payload
      # If current node is NOT in a collection
      # Example use case: single node bindings (e.g., data_point.startedAt)
      # TODO(syu): more elegant way to handle this distinction
      else
        @get('controller').send 'commitLiteral', payload


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
    if @get 'isActive'
      return
    else
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
    console.log "FocusOut:", "currentTarget:", e.currentTarget, "target:", e.target, "related", e.relatedTarget


    @get('controller').send('activateNode', null)
    payload =
      key: @keyField()?.val()
      val: @valField()?.val()
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

    # prepare payload: pull from $().val, etc
    # send to `commitEverything

    #node = @get('nodeContent')
    ###
    payload =
      key: @keyField()?.val()
      node: node

    # if the value has been modified, include val in the payload
    if @valField()?.val() isnt @get("templateStrings.asString")
      payload.val = @valField()?.val()
    console.log('focusOut, payload', payload)
    ###


      # @get('controller').send 'commitEverything', payload

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

  # normally, there is a 5px gap at the bottom of node-collections to make room for the [ ] and { } glyphs.
  # However, if multiple collections all exit, we don't want a ton of white space, so we only show the gap
  # if this nodeCollection has an additional sibling after it
  suppressGap: (->
    @get('nodeContent.nodeParent.nodeVal.lastObject') == @get('nodeContent')
  ).property('nodeContent.nodeParent.nodeVal.lastObject')

  ##
  # For each child content editable field, this calls refresh()
  # Context: This is necessary to reinsert the "display string"
  #  of a val field, when an edit to the input is made, but the
  #  parsed nodeVal is still the same
  repaint: ->
    @get("childViews").forEach( (view) ->
      if view instanceof Sysys.ContentEditableField
        view.refresh()
    )

  willDestroyElement: ->
    @get('nodeContent')?.set 'nodeView', null

  didInsertElement: ->
    @get('nodeContent')?.set 'nodeView', @

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

    # get the field view
    # NOTE this gets the FIRST instance of child field of this type
    fieldView = @["#{opts.field}Field"]()

    console.log "focusing field, field: #{opts.field}, pos: #{opts.pos}, opts: #{JSON.stringify opts} fieldView: ", fieldView.$()


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
