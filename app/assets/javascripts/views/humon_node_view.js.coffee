Sysys.HumonNodeView = Ember.View.extend
  testEvent: (e) ->
    debugger
  _focusedField: null
# templateName: 'humon_node'
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
  # templateName: "humon_node"
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.nodeType',
    'isActive:active',
    'parentActive:activeChild',
    'suppressGap']
  classNames: ['node']

  # focusIn
  #  1) cancels propagation
  #  2) if current HNV is active returns and does nothing
  #     if current HNV is not active,  calls activateNode on the current node content
  #
  #  This is primarily called indirectly by event bubbling from content fields
  focusIn: (e) ->
    console.log 'humon node view focusing in '
    # console.log "   currently focused item is", $(':focus')
    e.stopPropagation()
    if @get 'isActive'
      console.log "    canceled because node is already active"
      return
    else
      console.log "    calling transitionToNode"
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
    console.log 'hnv focusing out'
    # TODO(syu):
    # prepare payload: pull from $().val, etc
    # send to `commit`
    node = @get('nodeContent')
    console.log('commitingEverything, nodeKey=', node.get('nodeKey'))
    console.log('commitingEverything, node=', node.get('nodeVal'))
    console.log('commitingEverything, activeNodeKey =', @get('controller.activeHumonNode.nodeKey'))
    console.log('commitingEverything, activeNode =', @get('controller.activeHumonNode.nodeVal'))
    payload =
      key: @$keyField().val()
      node: node
    if @$valField().val() isnt @get("templateStrings.asString")
      payload.val = @$valField().val()
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
  smartFocus: ->
    node = @get('nodeContent')
    context = node.get('nodeParent.nodeType') || "hash"
    nodeKey = node.get('nodeKey')
    nodeVal = @$valField().val()
    isLiteral = node.get('isLiteral')
    isCollection = node.get('isCollection')
    opts = {}
    if context == 'hash' && isLiteral && nodeKey && !nodeVal
      opts.field = 'label'
    else if context == 'hash' && !nodeKey
      opts.field = 'label'
    else if context =='hash' && isCollection
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
    # TODO(syu): should be
    #   1. trigger 'try to transitionTonode'
    #   2. smartFocus to set the focus
    # @get('controller').activateNode @get('nodeContent'), focus: true
    # e.stopPropagation()
    console.log 'hnv click'
    e.stopPropagation()
    unless @get('isActive')
      @get('controller').send('activateNode', @get('nodeContent'))
    console.log '  smart focusing'
    @smartFocus()

  # up -- handles the event of moving to the previous node
  # Context: TODO(syu)
  #   1) calls prevNode on the controller
  #   2) if prevNode was successful (returns a new node), then send smartFocus to controller
  up: (event = null) ->
    if @get('controller').prevNode() #send('prevNode')
      @set "_focusedField", null
      console.log "HNV#up; active node key = #{@get('controller.activeHumonNode.nodeKey')}"
      Ember.run.sync()
      @get('controller').send 'smartFocus'

  down: (event = null) ->
    if changed = @get('controller').nextNode() #send('nextNode')
      @set "_focusedField", null
      console.log "HNV#down; active node key = #{@get('controller.activeHumonNode.nodeKey')}"
      Ember.run.sync()
      @get('controller').send 'smartFocus'


  json_string: (->
    JSON.stringify @get('nodeContent.json')
  ).property('nodeContent.json')

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
    # @animDestroy()
    @unbindHotkeys()
    @get('nodeContent')?.set 'nodeView', null

  didInsertElement: ->
    if @get("_focusedField")
      @focusField(@get("_focusedField"))
      @set "_focusedField", null
    @initHotkeys()
    @get('nodeContent')?.set 'nodeView', @


  unbindHotkeys: Em.K

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>

  $labelField: ->
    @$('> span> .content-field.label-field')?.first()
  $keyField: ->
    field = @$('> span > .content-field.key-field')?.first()
    field
  $idxField: ->
    @$('> span > .content-field.idx-field')?.first()
  $valField: ->
    field = @$('> span > .content-field.val-field')?.first()
    field

  focusField: (opts) ->
    if typeof arg is String
      opts = field: opts
    $field = @["$#{opts.field}Field"]()
    $field.focus()
    if opts.pos == "left"
      setCursor($field.get(0), 0)
    if opts.pos == "right"
      setCursor($field.get(0), $field.val().length)

  moveLeft: ->
    @set '_focusedField',
      field: 'label'
      pos: 'right'
    @focusField @get '_focusedField'

  moveRight: ->
    @set '_focusedField',
      field: 'val'
      pos: 'left'
    @focusField @get '_focusedField'



  commitAndContinue: ->
    if @$valField().val() == ''
      @$valField().val '{}'
    payload =
      val: @$valField().val()
      key: @$keyField().val()
    @get('controller').send 'commitAndContinueNew', payload

Sysys.DetailView = Sysys.HumonNodeView.extend
  init: ->
    Ember.run.sync() # <-- need to do this because nodeContentBinding hasn't propagated yet
    @_super()

  didInsertElement: ->
    Ember.run.sync()
    @_super()

  focusOut: (e) ->
    if @get('controller')
      @get('controller').send('activateNode', null)

Sysys.HumonRootView = Sysys.HumonNodeView.extend
  init: ->
    Ember.run.sync() # <-- need to do this because nodeContentBinding hasn't propagated yet
    @_super()

  didInsertElement: ->
    Ember.run.sync()
    @_super()

  focusOut: (e) ->
    if @get('controller')
      @get('controller').send('activateNode', null)

