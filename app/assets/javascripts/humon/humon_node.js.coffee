Sysys.HumonNode = Ember.Object.extend Ember.Comparable,
  nodeKey: ''
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  keyBinding: 'nodeKey'
  compare: (hna, hnb) -> 
    a = hna.get('nodeVal')
    b = hnb.get('nodeVal')
    as = bs = null
    ret = 
      if hna.get('nodeType') == 'date' || hnb.get('nodeType') == 'date'
        Ember.compare(a, b)
      else
        0
    ret

  # finds the index of this node in its parentNode's nodeVal (children)
  # if parentNode does not exist, returns undefined
  # otherwise, returns the index (as an int)
  nodeIdx: ((key, val)->
    if arguments.length > 1
      @get('nodeParent.nodeVal')?.indexOf @
    @get('nodeParent.nodeVal')?.indexOf @
  ).property('nodeParent.nodeVal.@each', 'nodeParent.nodeVal')

  json: (->
    Sysys.HumonUtils.humonNode2json @
  ).property('nodeVal', 'nodeKey', 'nodeType').cacheable false

  ###
  nodeValChanged: (->
    @get('nodeParent')?.notifyPropertyChange 'nodeVal'
  ).observes 'nodeVal', 'nodeKey', 'nodeType', 'nodeVal.@each'
    ###

  isHash: (->
    @get('nodeType') == 'hash'
  ).property('nodeType')

  isList: (->
    @get('nodeType') == 'list'
  ).property('nodeType')

  isCollection: (->
    @get('isList') || @get('isHash')
  ).property 'nodeType'

  hasChildren: (->
    !!(@get('isCollection') && @get('nodeVal').length)
  ).property('isCollection', 'nodeVal', 'nodeVal.@each')

  isLiteral: (->
    ['literal', 'date']
    @get('nodeType') == 'literal' || @get('nodeType') == 'date'
  ).property('nodeType')

  # Retrieves a node by key or by index.
  # If keyOrIndex has type number, retrieves the keyOrIndex'th element of nodeVal
  # Otherwise, if this node is a list, attempts to get the keyOrIndex on the nodeVal
  # Otherwise, if this node is a hash, searches nodeVal for an element with nodeKey equal to keyOrIndex
  # otherwise, return undefined
  # Precondition: this node is a collection
  getNode: (keyOrIndex) ->
    Em.assert("HumonNode must be a list or a hash to getNode(#{keyOrIndex})", @get('isHash') || @get('isList'))
    nodeVal = @get('nodeVal')
    childNode =
      if @get('isList') || typeof keyOrIndex == "number"
        nodeVal.get keyOrIndex
      else if @get('isHash')
        nodeVal.findProperty('nodeKey', keyOrIndex)
    return childNode

  # returns a flat array representing this node and its contents
  # literals return an array with a single element
  # node-collections return an array with the first element as the node
  flatten: ->
    if @get('isLiteral')
     [ @ ]
    else
      @get('nodeVal').reduce (x, y) ->
        x.concat(y.flatten())
      , [ @ ]

  # calls flatten then gets the last child
  # flatten should never be empty
  lastFlattenedChild: ->
    arr = @flatten()
    arr[arr.length-1]

  # Public
  # returns the next node in the 'flattened' representation of the the entire node tree
  # if no such node exists, returns null
  nextNode:  ->
    if @get('hasChildren')
      return @get('nodeVal')[0]
    curNode = @
    isLastChild = (child) ->
      child.get('nodeParent.nodeVal')[ child.get('nodeParent.nodeVal').length - 1 ] == child

    while curNode.get('nodeParent') and isLastChild(curNode)
      curNode = curNode.get('nodeParent')
    i = curNode.get('nodeParent.nodeVal')?.indexOf(curNode) + 1
    return curNode.get('nodeParent.nodeVal')[i] if i
    null

  # public
  # returns the previous node in the 'flattened' representation of the the entire node tree
  # if no such node exists, returns null
  prevNode: ->
    # there can be no previous node if there is no parent (and therefore no siblings)
    unless @get('nodeParent')
      return null
    # if this is the first child, the previous node is just the parent
    if @get('nodeParent.nodeVal')[0] == @
      return @get('nodeParent')
    # otherwise, start at the previous sibling
    curNode = @get('nodeParent.nodeVal')[ @get('nodeParent.nodeVal').indexOf(@) - 1 ]
    # while the sibling we're exploring has children, follow the last child
    while curNode.get('hasChildren')
      curNode = curNode.get('nodeVal')[ curNode.get('nodeVal').length - 1 ]
    curNode

  #TODO(syu): test me
  convertToHash: ->
    Em.assert('HumonNode must be a collection to convert to hash', @get('isCollection'))
    return if @get('isHash')
    @set('nodeType', 'hash')
    for node, idx in @get('nodeVal')
      # set the key unless nodeKey 1) exists 2) is nonempty
      node.set 'nodeKey', "#{idx}" unless node.get('nodeKey')

  #TODO(syu): test me
  convertToList: ->
    Em.assert('HumonNode must be a collection to convert to hash', @get('isCollection'))
    return if @get('isList')
    @set 'nodeType', 'list'

  # replaces the CURRENT NODE with the json value
  # calls @replaceWithHumonNode underlying
  replaceWithJson: (json)->
    humonNode = Sysys.j2hn json
    @replaceWithHumonNode humonNode

  # Private
  # precondition: newNode has no parent
  # replaces the CURRENT NODE's  nodeVal with newNode's nodeVal by REFERENCE
  # this.nodeVal will point to newnNode.nodeVal
  # If newNode is a collection, sets each of the children's nodeParent to this node
  # If thisNode is a collection, sets each of this children's nodeParent to null
  replaceWithHumonNode: (newNode)->
    Em.assert "replaceWithHumonNode(newNode): newNode must be parent less", !newNode.get('nodeParent')
    if @get 'hasChildren'
      for child in @get('nodeVal')
        child.set 'nodeParent', null
    @set('nodeVal', newNode.get 'nodeVal')
    @set('nodeType', newNode.get 'nodeType')
    if @get 'hasChildren'
      for child in @get('nodeVal')
        child.set 'nodeParent', @

  # Public
  # precondition: node is a collection node
  # replaces objects in 
  replaceAt: (idx, amt, nodes...) ->
    Em.assert("HumonNode must be a list or a hash to replaceAt(#{idx},#{amt},#{nodes})", @get('isCollection'))
    list = @get 'nodeVal'

    # set the `nodeParent` for the removed nodes to null 
    end = Math.min(idx + amt, list.length)
    for i in [idx...end]
      list[i]?.set('nodeParent', null)

    # set the nodeParent for the inserted nodes to this node
    if nodes?
      for node in nodes
        node.set('nodeParent', @)

    list.replace idx, amt, nodes

  # Public
  # inserts nodes... into the nodeVal array immediately before idx
  # sets the nodeParent for inserted children to this node
  # precondition: this node is a collection
  insertAt: (idx, nodes...) ->
    Em.assert("HumonNode must be a list or a hash to insertAt(#{idx},#{nodes})", @get('isCollection'))
    args = [idx, 0].concat nodes
    @replaceAt.apply @, args

  # Public
  # deletes `amt` elements from the nodeVal array, starting at idx, inclusive.
  # if amt is not specified, a single element is deleted
  # if the number of elements to be deleted is greater than the remaining elements in the array, the remaining elemtns are deleted
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
  deleteChild: (node)->
    Em.assert('Child argument must be a child of this node for deleteChild', node.get('nodeParent') == @)
    idx = node.get('nodeIdx')
    @deleteAt(idx)
