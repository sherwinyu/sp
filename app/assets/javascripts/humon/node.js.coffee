Humon.Node = Ember.Object.extend
  controller: null
  # Binding: 'nodeView.controller'
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  nodeKey: null
  nodeMeta: null
  invalid: false
  invalidReason: ""


  initialized: true
  readOnlyBinding: 'nodeMeta.readOnly'
  nodeIdx: ((key, val)->
    @get('nodeParent.children')?.indexOf @
  ).property('nodeParent.children.@each', 'nodeParent.children')

  toJson: ->
    @get('nodeVal').toJson()
  val: ->
    @get('nodeVal').toJson()
  asString: ->
    @get('nodeVal').asString()
  unknownProperty: (key) ->
    @get("nodeVal.#{key}") #.get(key)

  ##
  # @return true if no errors were found
  #         false otherwise
  #
  #         if errors are found,
  validate: ->
    {valid, errors} = @get('nodeVal').validate()
    if not valid
      @invalidate( errors )
    else # is valid!
      @clearInvalidation()
      if @get('nodeParent')
        valid &&= @get('nodeParent').validate()
    return valid

  clearInvalidation: ->
    # Note, in the case of hidden nodes, don't do this
    nv = @get('nodeView')
    if nv?
      nv.enableTemplateStrings()
    else
      console.warn "#{@}#clearInvalidation: node view not found"
    @set('initialized', true)
    @set('invalidReason', null)
    @set('invalid', false)

  invalidate: (reason) ->
    nv = @get('nodeView')
    if nv?
      nv.clearTemplateStrings()
    else
      console.warn "#{@}#clearInvalidation: node view not found"
    @set('invalidReason', reason)
    @set('invalid', true)

  tryToCommit: (payload) ->
    jsonInput = payload.val
    {coerceSuccessful, coercedInput} = @get('nodeVal').precommitInputCoerce(jsonInput)

    jsonInput = coercedInput if coerceSuccessful

    try
      json = try
              # TODO(syu): -- probably shouldn't do this if we have the metatemplate
              # e.g., no reason to convert "[1, 2, 3]" into [1, 2, 3] if we
              # know the val is supposed to be a string
              JSON.parse(jsonInput)
            catch error
              jsonInput
      node = HumonUtils.json2node json, metatemplate: @get('nodeMeta'), suppressNodeParentWarning: yes, controller: @controller
    catch error
      Em.assert("The error should be: UnableToConvertInputToNode", true)
      console.error(error.toString())
      # Error will be if jsonInput doesn't fit supplied metaTemplate
      # TODO(syu): can also be eerror if jsonInput doesn't fit ANY node
      nv = @get('nodeView')
      if nv?
        nv.clearTemplateStrings()
        nv.flashWarn("Couldn't convert type")
      else
        console.warn "#{@}#clearInvalidation: node view not found"
      return
    @replaceWithHumon node

    # At this point, commit was successful!
    # Set valid to true (for self)
    @clearInvalidation()
    if payload.key?
      @set('nodeKey', payload.key) if payload.key?

    # Bubbles up the NODE hierarchy
    if @validate()
      @get('controller').send 'didCommit',
        node: @
        rootJson: @get('controller.content').val()
        payload: json

  # Precondition: newNode has no parent
  # Replaces the CURRENT NODE's  nodeVal with newNode's nodeVal by REFERENCE
  # This.nodeVal will point to newNode.nodeVal
  # If newNode is a collection, sets each of the children's nodeParent to this node
  # If thisNode is a collection, sets each of this children's nodeParent to null
  # TODO rename to replaceWithNode
  replaceWithHumon: (newNode) ->
    Em.assert "replaceWithHumonNode(newNode): newNode must be parent less", !newNode.get('nodeParent')
    # If THIS nodevalue has children, orphan them
    if @get 'hasChildren'
      for child in @get('children')
        child.set 'nodeParent', null

    # TODO write a test for me! Especially the nodeVal.node backreference case
    @set('nodeType', newNode.get 'nodeType')
    @set('nodeVal', newNode.get 'nodeVal')
    @set('nodeVal.node', @)

    if @get 'hasChildren'
      for child in @get('children')
        child.set 'nodeParent', @

  insertAt: (idx, nodes...) ->
    args = [idx].concat nodes
    @get('nodeVal').insertAt.apply(@get('nodeVal'), args)

  # Public
  # Deletes `amt` elements from the nodeVal array, starting at idx, inclusive.
  # If amt is not specified, a single element is deleted
  # If the number of elements to be deleted is greater than the remaining elements in the array, the remaining elemtns are deleted
  # sets the nodeParent for deleted nodes to null
  deleteAt: (idx, amt) ->
    @get('nodeVal').deleteAt(idx, amt)


  # Public
  # precondition: node must be a child of this node
  # removes the child node from this.nodeVal array
  # sets node's nodeParent to null
  deleteChild: (node) ->
    @get('nodeVal').deleteChild(node)

  # Public
  # @returns Humon.Node the next node in the 'flattened' representation of the entire
  # node tree. If no such node exists, returns null
  nextNode: ->
    if @get('hasChildren')
      return @get('children')[0]
    curNode = @
    isLastChild = (child) ->
      child.get('nodeParent.children')[ child.get('nodeParent.children.length') - 1] == child
    while curNode.get('nodeParent') and isLastChild(curNode)
      curNode = curNode.get('nodeParent')
    if curNode.get('nodeParent')
      i = curNode.get('nodeParent.children').indexOf(curNode) + 1
      return curNode.get("nodeParent.#{i}")
    null

  prevNode: ->
    unless @get('nodeParent')
      return null
    # If this is the first child, then previous node is just the parent
    return @get('nodeParent') if @get('nodeParent.children.0') == @

    # Otherwise, start at the previous sibling
    siblings = @get('nodeParent.children')
    curNode = siblings[siblings.indexOf(@) - 1]
    # And keep following the last child
    while curNode.get('hasChildren')
      curNode = curNode.get('children.lastObject')
    return curNode

  flatten: ->
    @get('nodeVal').flatten()

  lastFlattenedChild: ->
    arr = @flatten()
    arr[arr.length - 1]

  pathToNode: (testNode) ->
    if @ == testNode
      return [@]
    else if @get 'isCollection'
      for child in @get 'children'
        if curPath = child.pathToNode( testNode )
          return [@].concat curPath
      null
    else
      null

  isDescendant: (testNode) ->
    path = @pathToNode(testNode)
    !!path

