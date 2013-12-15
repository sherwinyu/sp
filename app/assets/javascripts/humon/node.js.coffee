Humon.Node = Ember.Object.extend
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  nodeKey: null
  nodeMeta: null

  ###
  isHashBinding: Ember.Binding.oneWay('nodeVal.isHash')
  isListBinding: Ember.Binding.oneWay('nodeVal.isList')
  isCollectionBinding: Ember.Binding.oneWay('nodeVal.isCollection')
  isLiteralBinding: Ember.Binding.oneWay('nodeVal.isLiteral')
  hasChildrenBinding: Ember.Binding.oneWay('nodeVal.hasChildren')
  ###

  nodeIdx: ((key, val)->
    @get('nodeParent.children')?.indexOf @
  ).property('nodeParent.children.@each', 'nodeParent.children')

  flatten: ->
    @get('nodeVal').flatten()

  lastFlattenedChild: ->
    arr = @flatten()
    arr[arr.length - 1]

  tryToCommit: (jsonInput) ->
    if @get('nodeVal').precommitInputCoerce(jsonInput)
      return
    try
      json = try
              # TODO(syu): -- probably shouldn't do this if we have the metatemplate
              # e.g., no reason to convert "[1, 2, 3]" into [1, 2, 3] if we
              # know the val is supposed to be a string
              JSON.parse(jsonInput)
            catch error
              jsonInput
      node = HumonUtils.json2node json, metatemplate: @get('nodeMeta')
    catch error
      Em.assert("The error is: UnableToConvertInputToNode")
      # Error will be if jsonInput doesn't fit supplied metaTemplate
      # TODO(syu): can also be eerror if jsonInput doesn't fit ANY node
      debugger
      @invalidate("Provided string doesn't fit into this node's type.")
      return
    @replaceWithHumon node
    @get('nodeView').repaint()

  invalidate: (reason) ->
    @set('invalidReason', reason)
    @set('valid', false)

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

  # TODO figure out how to send `context` to `json2node`
  replaceWithJson: (json) ->
    node = HumonUtils.json2node json
    @replaceWithHumon node

  # Private
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

    # If newnode has children, set their parent to this
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

  convertToHash: ->
    throw new Error "Not implemented yet"

  convertToList: ->
    throw new Error "Not implemented yet"

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

  unknownProperty: (key) ->
    @get("nodeVal.#{key}") #.get(key)

  toJson: ->
    @get('nodeVal').toJson()

  val: ->
    @get('nodeVal').toJson()

  asString: ->
    @get('nodeVal').asString()
