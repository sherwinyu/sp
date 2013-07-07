shu = Sysys.HumonUtils

describe "HumonNode", ->
  j2hn = shu.json2humonNode
  node = nodea = nodeb = nodec = nodec0 = nodec1 = nodec2 = nodec2nested = noded = nodee = null
  newNode = null

  ######### SAMPLE ###########
  beforeEach ->
    json_src = {a: 1, b: 2, c: [false, 'lalala', {nested: true}], d:[], e: {}}
    node = j2hn json_src #TODO(syu): technically, shouldn't rely on this...
    nodea = node.get('nodeVal').findProperty('nodeKey', 'a')
    nodeb = node.get('nodeVal').findProperty('nodeKey', 'b')
    nodec = node.get('nodeVal').findProperty('nodeKey', 'c')
    nodec0 = nodec.get('nodeVal.0')
    nodec1 = nodec.get('nodeVal.1')
    nodec2 = nodec.get('nodeVal.2')
    nodec2nested = nodec2.get('nodeVal').findProperty('nodeKey', 'nested')
    noded = node.get('nodeVal').findProperty('nodeKey', 'd')
    nodee = node.get('nodeVal').findProperty('nodeKey', 'e')
  ######### SAMPLE ###########

  describe "attributes", ->
    it "should have the expected attributes (root node)", ->
      expect(node.get 'nodeVal').toEqual [nodea, nodeb, nodec, noded, nodee]
      expect(node.get('nodeType')).toBe 'hash'
      expect(node.get('nodeParent')).toBe null
      expect(node.get('nodeKey')).toEqual ''
      expect(node.get('nodeIdx')).toBe undefined
      expect(node.get('nodeView')).toBe null
    it "should have the expected attributes (leaf node)", ->
      expect(nodea.get('nodeVal')).toBe 1
      expect(nodea.get('nodeType')).toBe 'number'
      expect(nodea.get('nodeParent')).toBe node
      expect(nodea.get('nodeKey')).toBe 'a'
      expect(nodea.get('nodeIdx')).toBe 0
      expect(node.get('nodeView')).toBe null
    it "should have the expected attributes (intermediate node)", ->
      expect(nodec.get('nodeVal')).toEqual [nodec0, nodec1, nodec2]
      expect(nodec.get('nodeType')).toBe 'list'
      expect(nodec.get('nodeParent')).toBe node
      expect(nodec.get('nodeKey')).toBe 'c'
      expect(nodec.get('nodeIdx')).toBe 2
      expect(node.get('nodeView')).toBe null
    it "should have the expected attributes (empty list)", ->
      expect(noded.get 'nodeVal').toEqual []
      expect(noded.get 'nodeType').toBe 'list'
      expect(noded.get 'nodeParent').toBe node
      expect(noded.get 'nodeKey').toBe 'd'
      expect(noded.get 'nodeIdx').toBe 3
    it "should have the expected attributes (empty hash)", ->
      expect(nodee.get 'nodeVal').toEqual []
      expect(nodee.get 'nodeType').toBe 'hash'
      expect(nodee.get 'nodeParent').toBe node
      expect(nodee.get 'nodeKey').toBe 'e'
      expect(nodee.get 'nodeIdx').toBe 4

  describe "computed properties", ->
    describe "isHash", ->
      it "should return true when nodeType is hash, false otherwise", ->
        expect(node.get('isHash')).toBe true
        expect(nodea.get('isHash')).toBe false
        expect(nodec.get('isHash')).toBe false
    describe "isList", ->
      it "should return true when nodeType is list, false otherwise", ->
        expect(node.get('isList')).toBe false
        expect(nodea.get('isList')).toBe false
        expect(nodec.get('isList')).toBe true
    describe "isCollection", ->
      it "should return true when nodeType is list or hash, false otherwise", ->
        expect(node.get('isCollection')).toBe true
        expect(nodea.get('isCollection')).toBe false
        expect(nodec.get('isCollection')).toBe true
        expect(noded.get('isCollection')).toBe true
        expect(nodee.get('isCollection')).toBe true
    describe "hasChildren", ->
      it "should return true when nodeType is list or hash and nonempty, false otherwise", ->
        expect(node.get('hasChildren')).toBe true
        expect(nodea.get('hasChildren')).toBe false
        expect(nodec.get('hasChildren')).toBe true
        expect(noded.get('hasChildren')).toBe false
        expect(nodee.get('hasChildren')).toBe false
    describe "isLiteral", ->
      it "should return true when nodeType is list or hash, false otherwise", ->
        expect(node.get('isLiteral')).toBe false
        expect(nodea.get('isLiteral')).toBe true
        expect(nodec.get('isLiteral')).toBe false
        expect(noded.get('isLiteral')).toBe false
        expect(nodee.get('isLiteral')).toBe false

  describe "methods", ->
    describe "nextNode", ->
      it "should work for the root node", ->
        expect(node.nextNode()).toBe nodea
      it "should work when going up the tree to a sibling", ->
        expect(nodea.nextNode()).toBe nodeb
        expect(nodeb.nextNode()).toBe nodec
      it "should work when diving into the tree", ->
        expect(nodec.nextNode()).toBe nodec0
        expect(nodec0.nextNode()).toBe nodec1
        expect(nodec1.nextNode()).toBe nodec2
      it "should work when diving nested into the tree", ->
        expect(nodec2.nextNode()).toBe nodec2nested
      it "should work when node is empty collection", ->
        expect(noded.nextNode()).toBe nodee
      it "should return null when there's nothing left to recurse", ->
        expect(nodee.nextNode()).toBe null
      it "should return null on a lone node", ->
        hn = j2hn 1
        expect(hn.nextNode()).toBe null

    describe "prevNode", ->
      it "should return null on the root", ->
        expect(node.prevNode()).toBe null
      it "should point up the parent if its a first child", ->
        expect(nodea.prevNode()).toBe node
        expect(nodec0.prevNode()).toBe nodec
        expect(nodec2nested.prevNode()).toBe nodec2
      it "should go to the previous sibling if available", ->
        expect(nodeb.prevNode()).toBe nodea
        expect(nodec.prevNode()).toBe nodeb
        expect(nodec1.prevNode()).toBe nodec0
        expect(nodec2.prevNode()).toBe nodec1
      it "should go down the tree", ->
        noded = j2hn 1
        noded.set 'nodeKey', 'd'
        node.replaceAt(3, 0, noded)
        expect(noded.prevNode()).toBe nodec2nested
      it "should go in order", ->
        expect(node.prevNode()).toBe null
        expect(nodea.prevNode()).toBe node
        expect(nodeb.prevNode()).toBe nodea
        expect(nodec.prevNode()).toBe nodeb
        expect(nodec0.prevNode()).toBe nodec
        expect(nodec1.prevNode()).toBe nodec0
        expect(nodec2.prevNode()).toBe nodec1
        expect(nodec2nested.prevNode()).toBe nodec2
        expect(noded.prevNode()).toBe nodec2nested
        expect(nodee.prevNode()).toBe noded

    describe "getNode", ->
      it "should fail if the node isn't a hash or a list", ->
        expect(-> nodea.getNode '0').toThrow()
        expect(-> nodea.getNode 'asdf').toThrow()

      it "should return the proper humonNode object on a hash", ->
        expect(node.getNode 'a').toBe nodea
        expect(node.getNode 'b').toBe nodeb
        expect(node.getNode 'c').toBe nodec
        expect(nodec2.getNode 'nested').toBe nodec2nested

      it "should return the proper humonNode object on a list", ->
        expect(nodec.getNode '0').toBe nodec0
        expect(nodec.getNode '1').toBe nodec1
        expect(nodec.getNode '2').toBe nodec2
      xit "should work for nested paths (e.g. hash.a.0)"

    describe "replaceAt", ->
      it "should replace at index 0 ", ->
        newNode = j2hn "wala"
        node.replaceAt 0, 0, newNode
        expect(node.get('nodeVal.0')).toBe newNode
        expect(node.get('nodeVal.1')).toBe nodea
        node.replaceAt 0, 2, nodec0, nodec1
        expect(node.get('nodeVal')[0]).toEqual nodec0
        expect(node.get('nodeVal')[1]).toEqual nodec1
        expect(node.get('nodeVal')[2]).toEqual nodeb
        expect(node.get('nodeVal')[3]).toEqual nodec
        expect(node.get('nodeVal')[4]).toEqual noded
        expect(node.get('nodeVal')[5]).toEqual nodee
      it "should remove elements", ->
        # remove 3 items
        nodec.replaceAt 1, 3
        expect(nodec.get('nodeVal.0')).toBe nodec0
        expect(nodec.get('nodeVal.1')).toBe undefined
        expect(nodec.get('nodeVal.2')).toBe undefined
        expect(nodec.get('nodeVal.length')).toBe 1
        # remove 2 items and add 1
        newNode = j2hn "wala"
        node.replaceAt 1, 2, newNode
        expect(node.get('nodeVal.0')).toBe nodea
        expect(node.get('nodeVal.1')).toBe newNode
        expect(node.get('nodeVal.2')).toBe noded
        expect(node.get('nodeVal.3')).toBe nodee
        expect(node.get('nodeVal.length')).toBe 4
      it "should accept a single element as objects", ->
        newNode = j2hn "wala"
        node.replaceAt 1, 1, newNode
        expect(node.get 'nodeVal.1').toBe newNode
      it "should accept a multiple elements as objects", ->
        newNode0 = j2hn "wala"
        newNode1 = j2hn "wala"
        node.replaceAt 1, 2, newNode0, newNode1
        expect(node.get 'nodeVal.1').toBe newNode0
        expect(node.get 'nodeVal.2').toBe newNode1
      it 'should set the parent node properly', ->
        newNode0 = j2hn "wala"
        newNode1 = j2hn "walb"
        newNode2 = j2hn "walc"
        node.replaceAt 1, 2, newNode0, newNode1, newNode2
        expect(newNode0.get('nodeParent')).toBe node
        expect(newNode1.get('nodeParent')).toBe node
        expect(newNode2.get('nodeParent')).toBe node
      it "should throw when element node isn't a collection", ->
        expect(-> nodea.replaceAt 0, 0).toThrow()
      it "should unset the replaced nodes' nodeParent", ->
        # delete first 3 items
        node.replaceAt 0, 3
        expect(nodea.get('nodeParent')).toBe null
        expect(nodeb.get('nodeParent')).toBe null
        expect(nodec.get('nodeParent')).toBe null

    describe "replaceWithJson", ->
      it "should work when replacing with literal", ->
        nodec.replaceWithJson 'imaliteral'

        expect(nodec.get 'nodeType').toBe 'string'
        expect(nodec.get 'nodeParent').toBe node
        expect(nodec.get 'nodeVal').toBe 'imaliteral'

      it "should work when replacing with lists", ->
        nodeb.replaceWithJson [3,1]
        expect(nodeb.get 'nodeType').toBe 'list'
        expect(nodeb.get 'nodeParent').toBe node

        expect(nodeb.get('nodeVal.0.nodeVal')).toBe 3
        expect(nodeb.get('nodeVal.0.nodeType')).toBe 'number'
        expect(nodeb.get('nodeVal.0.nodeParent')).toBe nodeb

        expect(nodeb.get('nodeVal.1.nodeVal')).toBe 1
        expect(nodeb.get('nodeVal.1.nodeType')).toBe 'number'
        expect(nodeb.get('nodeVal.1.nodeParent')).toBe nodeb

      it "should work when replacing hashes", ->
        nodeb.replaceWithJson a: 3, b: 6
        expect(nodeb.get 'nodeType').toBe 'hash'
        expect(nodeb.get 'nodeParent').toBe node

        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeVal').toBe 3
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeType').toBe 'number'
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeParent').toBe nodeb

        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeVal').toBe 6
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeType').toBe 'number'
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeParent').toBe nodeb

      it "should work when replacing leafs", ->
        nodec2nested.replaceWithJson [true, false]

        expect(nodec2nested.get('nodeType')).toBe 'list'
        expect(nodec2nested.get('nodeParent')).toBe nodec2

        expect(nodec2nested.get('nodeVal.0.nodeVal')).toBe true
        expect(nodec2nested.get('nodeVal.0.nodeType')).toBe 'boolean'
        expect(nodec2nested.get('nodeVal.0.nodeParent')).toBe nodec2nested

        expect(nodec2nested.get('nodeVal.1.nodeVal')).toBe false
        expect(nodec2nested.get('nodeVal.1.nodeType')).toBe 'boolean'
        expect(nodec2nested.get('nodeVal.1.nodeParent')).toBe nodec2nested
    describe "replaceWithHumonNode", ->
      newNode = null
      describe "using a literal", ->
        beforeEach ->
          newNode = j2hn 'newNode'
          newNode.set 'nodeKey', 'somekey'
          nodec.replaceWithHumonNode newNode
        it "should set the nodeVal to newNode's nodeVal", ->
          expect(nodec.get('nodeVal')).toBe newNode.nodeVal
        it "should set the nodeType to newNode's nodeType", ->
          expect(nodec.get('nodeType')).toBe 'string'
        it "should not set nodeKey", ->
          expect(nodec.get('nodeKey')).toBe 'c'
        it "should set nodeParent to null for the replaced children nodes", ->
          expect(nodec0.get 'nodeParent').toBe null
          expect(nodec1.get 'nodeParent').toBe null
          expect(nodec2.get 'nodeParent').toBe null

      describe "using a collection", ->
        newNode0 = newNode1 = null
        beforeEach ->
          newNode = j2hn ['newNode', 1]
          newNode0 = newNode.get('0')
          newNode1 = newNode.get('1')
          newNode.set 'nodeKey', 'somekey'
          nodec.replaceWithHumonNode newNode
        it "should set the nodeVal to newNode's nodeVal", ->
          expect(nodec.get('nodeVal')).toBe newNode.nodeVal
        it "should set the nodeType to newNode's nodeType", ->
          expect(nodec.get('nodeType')).toBe 'list'
        it "should not set nodeKey", ->
          expect(nodec.get('nodeKey')).toBe 'c'
        it "should set nodeParent to null for the replaced children nodes", ->
          expect(nodec0.get 'nodeParent').toBe null
          expect(nodec1.get 'nodeParent').toBe null
          expect(nodec2.get 'nodeParent').toBe null
        it "should set the nodeParent of newNode's children to this node", ->
          expect(nodec.getNode '0.nodeParent').toBe nodec
          expect(nodec.getNode '1.nodeParent').toBe nodec

    describe "insertAt", ->
      newNode0 = newNode1 = newNode2 = null
      beforeEach ->
        newNode0 = j2hn 'scalar'
        newNode1 = j2hn [1, 2]
      it "with a single argument should insert the elements before the index", ->
        nodec.insertAt(1, newNode0)
        expect(nodec.getNode('0')).toBe nodec0
        expect(nodec.getNode('1')).toBe newNode0
        expect(nodec.getNode('2')).toBe nodec1
        expect(nodec.get('nodeVal.length')).toBe 4
      it "should work with multiple arguments", ->
        nodec.insertAt(1, newNode0, newNode1)
        expect(nodec.getNode('0')).toBe nodec0
        expect(nodec.getNode('1')).toBe newNode0
        expect(nodec.getNode('2')).toBe newNode1
        expect(nodec.getNode('3')).toBe nodec1
        expect(nodec.get('nodeVal.length')).toBe 5
      it "should insert elements before the idx at 0", ->
        nodec.insertAt(0, newNode0, newNode1)
        expect(nodec.getNode('0')).toBe newNode0
        expect(nodec.getNode('1')).toBe newNode1
        expect(nodec.getNode('2')).toBe nodec0
        expect(nodec.getNode('3')).toBe nodec1
        expect(nodec.get('nodeVal.length')).toBe 5
      it "should do nothing without nodes", ->
        nodec.insertAt(0)
        nodec.insertAt(1)
        nodec.insertAt(2)
        expect(nodec.getNode 0).toBe nodec0
        expect(nodec.getNode 1).toBe nodec1
        expect(nodec.getNode 2).toBe nodec2
        expect(nodec.get('nodeVal.length')).toBe 3
      it "should insert elements at the end when index is equal to length", ->
        nodec.insertAt(3, newNode0)
        expect(nodec.getNode('2')).toBe nodec2
        expect(nodec.getNode('3')).toBe newNode0
        expect(nodec.get('nodeVal.length')).toBe 4
      it "should insert elements at the end when index is greater than length", ->
        nodec.insertAt(400, newNode0)
        expect(nodec.getNode('2')).toBe nodec2
        expect(nodec.getNode('3')).toBe newNode0
        expect(nodec.get('nodeVal.length')).toBe 4
      it "should set inserted node's parent to this node", ->
        nodec.insertAt(2, newNode0, newNode1)
        expect(newNode0.get 'nodeParent').toBe nodec
        expect(newNode1.get 'nodeParent').toBe nodec

    describe "deleteAt", ->
      it "should do nothing when amt is 0", ->
        nodec.deleteAt 0, 0
        expect(nodec.getNode 0).toBe nodec0
        expect(nodec.getNode 1).toBe nodec1
        expect(nodec.getNode 2).toBe nodec2
        expect(nodec.get 'nodeVal.length').toBe 3
      it "should delete as much as it can when amt is big", ->
        nodec.deleteAt 1, 500
        expect(nodec.getNode 0).toBe nodec0
        expect(nodec.getNode 1).toBe undefined
        expect(nodec.get 'nodeVal.length').toBe 1
      it "should delete at idx 0", ->
        nodec.deleteAt 0, 3
        expect(nodec.get('nodeVal.length')).toBe 0
      it "should set deleted nodes' parent to null", ->
        nodec.deleteAt 0, 3
        expect(nodec0.get 'nodeParent').toBe null
        expect(nodec1.get 'nodeParent').toBe null
        expect(nodec2.get 'nodeParent').toBe null
      it "should work on hashes", ->
        node.deleteAt 3, 2
        expect(node.getNode 'a').toBe nodea
        expect(node.getNode 'b').toBe nodeb
        expect(node.getNode 'c').toBe nodec
        expect(node.getNode 'd').toBe undefined
        expect(node.getNode 'e').toBe undefined
      it "should throw when idx is non integral", ->
        expect(-> node.deleteAt 'asdf').toThrow()
      it "should default to deleting one element if amt is unspecified", ->
        node.deleteAt 3
        expect(node.getNode 0).toBe nodea
        expect(node.getNode 1).toBe nodeb
        expect(node.getNode 2).toBe nodec
        expect(node.getNode 3).toBe nodee
        expect(node.get 'nodeVal.length').toBe 4

    describe "deleteChild", ->
      it "should throw if deleted node is not a child of this node", ->
        expect( -> node.deleteChild nodec0).toThrow()
      it "should remove the child from this.nodeVal", ->
        node.deleteChild nodea
        expect(node.get('a')).toBe undefined
        expect(node.get('nodeVal.0')).not.toBe nodea
        expect(node.get('nodeVal.1')).not.toBe nodea
        expect(node.get('nodeVal.2')).not.toBe nodea
        expect(node.get('nodeVal.3')).not.toBe nodea
        expect(node.get('nodeVal.4')).not.toBe nodea
      it "should set the deleted child's nodeParent to null", ->
        node.deleteChild nodea
        expect(nodea.get 'nodeParent').toBe null

    describe "flatten", ->
      it "should work for literals", ->
        expect(nodea.flatten()).toEqual [nodea]
        expect(nodeb.flatten()).toEqual [nodeb]
      it "should include this node for collections", ->
        expect(node.flatten()[0]).toBe node
        expect(nodec.flatten()[0]).toBe nodec
        expect(nodec2.flatten()[0]).toBe nodec2
        expect(noded.flatten()[0]).toBe noded
        expect(nodee.flatten()[0]).toBe nodee
      it "should work for lists (nested)", ->
        flat = nodec.flatten()
        expect(flat[0]).toBe nodec
        expect(flat[1]).toBe nodec0
        expect(flat[2]).toBe nodec1
        expect(flat[3]).toBe nodec2
        expect(flat[4]).toBe nodec2nested
        expect(flat.length).toBe 5
      it "should work for empty collections", ->
        expect(noded.flatten()).toEqual [noded]
        expect(nodee.flatten()).toEqual [nodee]
      it "should work for the hashes (nested)", ->
        flat = node.flatten()
        expect(flat[0]).toBe node
        expect(flat[1]).toBe nodea
        expect(flat[2]).toBe nodeb
        expect(flat[3]).toBe nodec
        expect(flat[4]).toBe nodec0
        expect(flat[5]).toBe nodec1
        expect(flat[6]).toBe nodec2
        expect(flat[7]).toBe nodec2nested
        expect(flat[8]).toBe noded
        expect(flat[9]).toBe nodee
        expect(flat.length).toBe 10

    describe "lastFlattenedChild", ->
      it "should work on literals", ->
        expect(nodea.lastFlattenedChild()).toBe nodea
        expect(nodeb.lastFlattenedChild()).toBe nodeb
      it "should work on collections", ->
        expect(node.lastFlattenedChild()).toBe nodee
        expect(nodec.lastFlattenedChild()).toBe nodec2nested
        expect(nodec2.lastFlattenedChild()).toBe nodec2nested
        expect(nodec2nested.lastFlattenedChild()).toBe nodec2nested
      it "shouldwork on empty collections", ->
        expect(noded.lastFlattenedChild()).toBe noded
        expect(nodee.lastFlattenedChild()).toBe nodee

    describe "pathToNode", ->
      it "returns an array containing this node when the testnode is this literal node", ->
        expect(nodeb.pathToNode nodeb).toEqual [nodeb]
      it "returns an array containing this node when the testnode is this collection node", ->
        expect(nodec.pathToNode nodec).toEqual [nodec]
      it "returns an array containing this node when the testnode is this empty hash node", ->
        expect(nodee.pathToNode nodee).toEqual [nodee]
      it "returns an array containing this node to testnode when the testnode is a literal child", ->
        expect(node.pathToNode nodec0).toEqual [node, nodec, nodec0]
      it "returns an array containing this node to testnode (and not further) when the testnode is a collection child", ->
        expect(node.pathToNode nodec2).toEqual [node, nodec, nodec2]
      it "returns an array containing this node to testnode (and not further) when the testnode is an empty collection child", ->
        expect(node.pathToNode noded).toEqual [node, noded]
      it "returns an null when no path can be found", ->
        expect(noded.pathToNode node).toBeNull()

    describe "isDescendant", ->
      it "is true when testNode is a child", ->
      it "is true when testNode is a grand child", ->
      it "is true when testNode is a grand child with its own children", ->
