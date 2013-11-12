Humon.Node = Ember.Object.extend
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  nodeKey: null

  ###
  isHashBinding: Ember.Binding.oneWay('nodeVal.isHash')
  isListBinding: Ember.Binding.oneWay('nodeVal.isList')
  isCollectionBinding: Ember.Binding.oneWay('nodeVal.isCollection')
  isLiteralBinding: Ember.Binding.oneWay('nodeVal.isLiteral')
  hasChildrenBinding: Ember.Binding.oneWay('nodeVal.hasChildren')
  ###

  # TODO(syu): Delegate this look up to nodeVal
  nodeIdx: ((key, val)->
    @get('nodeParent.children')?.indexOf @
  ).property('nodeParent.children.@each', 'nodeParent.children')

  flatten: ->
    @get('nodeVal').flatten()

  lastFlattenedChild: ->
    Em.assert("Node contains a collection", @get('isCollection'))
    arr = @flatten()
    arr[arr.length - 1]

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

    @set('nodeType', newNode.get 'nodeType')
    @set('nodeVal', newNode.get 'nodeVal')

    # If newnode has children, set their parent to this
    if @get 'hasChildren'
      for child in @get('children')
        child.set 'nodeParent', @

  # Public
  # precondition: node is a collection node
  # replaces objects in
  replaceAt: (idx, amt, nodes...) ->
    Em.assert("HumonNode must be a list or a hash to replaceAt(#{idx},#{amt},#{nodes})", @get('isCollection'))
    children = @get 'children'

    # set the `nodeParent` for the removed nodes to null
    end = Math.min(idx + amt, children.length)
    for i in [idx...end]
      children[i]?.set('nodeParent', null)

    # set the nodeParent for the inserted nodes to this node
    if nodes?
      for node in nodes
        node.set('nodeParent', @)

    # TODO(syu) call underlying nodeVal and let it handle this
    children.replace idx, amt, nodes

  insertAt: (idx, nodes...) ->
    Em.assert("HumonNode must be a list or a hash to insertAt(#{idx},#{nodes})", @get('isCollection'))
    args = [idx, 0].concat nodes
    @replaceAt.apply @, args

  # Public
  # Deletes `amt` elements from the nodeVal array, starting at idx, inclusive.
  # If amt is not specified, a single element is deleted
  # If the number of elements to be deleted is greater than the remaining elements in the array, the remaining elemtns are deleted
  # sets the nodeParent for deleted nodes to null
  deleteAt: (idx, amt) ->
    Em.assert("deleteAt(idx, amt) requires idx to be an number", typeof idx == "number")
    amt ?= 1
    Em.assert("HumonNode must be a list or a hash to deleteAt(#{idx},#{amt})", @get('isCollection'))
    @replaceAt(idx, amt)

  # Public
  # precondition: node must be a child of this node
  # removes the child node from this.nodeVal array
  # sets node's nodeParent to null
  deleteChild: (node) ->
    Em.assert('Child argument must be a child of this node for deleteChild', node.get('nodeParent') == @)
    idx = node.get('nodeIdx')
    @deleteAt(idx)

  convertToHash: ->
    throw new Error "Not implemented yet"

  convertToList: ->
    throw new Error "Not implemented yet"

  pathToNode: (testNode) ->
    throw new Error "Not implemented yet"

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
