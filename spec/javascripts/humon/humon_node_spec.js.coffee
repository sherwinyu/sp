shu = Sysys.HumonUtils

describe "HumonNode", ->
  humonNode = null
  parentNode = null
  j2hn = shu.json2humonNode

  describe "attributes", ->

    beforeEach ->
      parentNode = Sysys.HumonNode.create
        nodeType: 'literal'
        nodeVal: 'parent'

      humonNode = Sysys.HumonNode.create
        nodeType: 'literal'
        nodeVal: 5
        nodeParent: parentNode
    it "should have the expected attributes", ->
      expect(humonNode.get('nodeVal')).toBe 5
      expect(humonNode.get('nodeType')).toBe 'literal'
      expect(humonNode.get('nodeParent')).toEqual parentNode

      expect(parentNode.get('nodeVal')).toBe 'parent'
      expect(parentNode.get('nodeType')).toBe 'literal'
      expect(parentNode.get('nodeParent')).toEqual null

  # hash = {a: 1, b: 2, c: [false, 'lalala', {nested: true}]}
  describe "methods", ->
    node = nodea = nodeb = nodec = nodec0 = nodec1 = nodec2 = nodec2nested = null

    beforeEach ->
      hash = {a: 1, b: 2, c: [false, 'lalala', {nested: true}]}
      node = j2hn hash #TODO(syu): technically, shouldn't rely on this...
      nodea = node.get('nodeVal').findProperty('nodeKey', 'a')
      nodeb = node.get('nodeVal').findProperty('nodeKey', 'b')
      nodec = node.get('nodeVal').findProperty('nodeKey', 'c')
      nodec0 = nodec.get('nodeVal.0')
      nodec1 = nodec.get('nodeVal.1')
      nodec2 = nodec.get('nodeVal.2')
      nodec2nested = nodec2.get('nodeVal').findProperty('nodeKey', 'nested')

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

      it "should return null when there's noting left to recurse", ->
        expect(nodec2nested.nextNode()).toBe null

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

    describe "getNode", ->
      it "should fail if the node isn't a hash or a list", ->
        expect(-> nodea.getNode '0').toThrow()
        expect(-> nodea.getNode 'asdf').toThrow()

      it "should return the proper humonNode object on a list", ->
        expect(node.getNode 'a').toBe nodea
        expect(node.getNode 'b').toBe nodeb
        expect(node.getNode 'c').toBe nodec
        expect(nodec2.getNode 'nested').toBe nodec2nested

      it "should return the proper humonNode object on a hash", ->
        expect(nodec.getNode '0').toBe nodec0
        expect(nodec.getNode '1').toBe nodec1
        expect(nodec.getNode '2').toBe nodec2
      xit "should work for nested paths (e.g. hash.a.0)"
      xit "should fail when getting non numeric keys on a list"
      xit "should fail when getting numeric keys on a hash"


    describe "replaceAt", ->
      it "should replace at index 0 ", ->
        newNode = j2hn "wala"
        node.replaceAt 0, 0, newNode
        expect(node.get('nodeVal.0')).toBe newNode
        expect(node.get('nodeVal.1')).toBe nodea
        node.replaceAt 0, 2, nodec0, nodec1
        expect(node.get('nodeVal')[0]).toEqual nodec0
        expect(node.get('nodeVal')[1]).toEqual nodec1 
        expect(node.get('nodeVal')[2]).toEqual nodeb,
        expect(node.get('nodeVal')[3]).toEqual nodec

      it "should remove elements", ->
        nodec.replaceAt 1, 3
        expect(nodec.get('nodeVal.0')).toBe nodec0
        expect(nodec.get('nodeVal.1')).toBe undefined
        expect(nodec.get('nodeVal.2')).toBe undefined
        expect(nodec.get('nodeVal.length')).toBe 1

        newNode = j2hn "wala"
        node.replaceAt 1, 2, newNode
        expect(node.get('nodeVal.0')).toBe nodea
        expect(node.get('nodeVal.1')).toBe newNode
        expect(node.get('nodeVal.2')).toBe undefined
        expect(node.get('nodeVal.length')).toBe 2

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

      it "should unset the replaced nodes' nodeParnet", ->
        throw 'pending'


    describe "replaceWithJson", ->
      it "should work when replacing with literal", ->
        nodec.replaceWithJson 'imaliteral'

        expect(nodec.get 'nodeType').toBe 'literal'
        expect(nodec.get 'nodeParent').toBe node
        expect(nodec.get 'nodeVal').toBe 'imaliteral'

      it "should work when replacing with lists", ->
        nodeb.replaceWithJson [3,1]
        expect(nodeb.get 'nodeType').toBe 'list'
        expect(nodeb.get 'nodeParent').toBe node

        expect(nodeb.get('nodeVal.0.nodeVal')).toBe 3
        expect(nodeb.get('nodeVal.0.nodeType')).toBe 'literal'
        expect(nodeb.get('nodeVal.0.nodeParent')).toBe nodeb

        expect(nodeb.get('nodeVal.1.nodeVal')).toBe 1
        expect(nodeb.get('nodeVal.1.nodeType')).toBe 'literal'
        expect(nodeb.get('nodeVal.1.nodeParent')).toBe nodeb

      it "should work when replacing hashes", ->
        nodeb.replaceWithJson a: 3, b: 6
        expect(nodeb.get 'nodeType').toBe 'hash'
        expect(nodeb.get 'nodeParent').toBe node

        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeVal').toBe 3
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeType').toBe 'literal'
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'a').get 'nodeParent').toBe nodeb

        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeVal').toBe 6
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeType').toBe 'literal'
        expect(nodeb.get('nodeVal').findProperty('nodeKey', 'b').get 'nodeParent').toBe nodeb

      it "should work when replacing leafs", ->
        nodec2nested.replaceWithJson [true, false]

        expect(nodec2nested.get('nodeType')).toBe 'list'
        expect(nodec2nested.get('nodeParent')).toBe nodec2

        expect(nodec2nested.get('nodeVal.0.nodeVal')).toBe true
        expect(nodec2nested.get('nodeVal.0.nodeType')).toBe 'literal'
        expect(nodec2nested.get('nodeVal.0.nodeParent')).toBe nodec2nested

        expect(nodec2nested.get('nodeVal.1.nodeVal')).toBe false
        expect(nodec2nested.get('nodeVal.1.nodeType')).toBe 'literal'
        expect(nodec2nested.get('nodeVal.1.nodeParent')).toBe nodec2nested

    describe "editKey", ->
      ###
      it "should fail if parent doesn't exist", ->
        expect(-> node.editKey 'new key').toThrow()
      it "should fail if parent is a list instead of a hash exist", ->
        expect(-> nodec0.editKey 'new key').toThrow()
      ###
      it "should coerce parent to a hash", ->
        throw "pending"
      it "should remove the old key association on the parent", ->
        nodeb.editKey "new key"
        expect(node.getNode('b')).not.toBeDefined()
      it "should add the new key association on the parent", ->
        nodeb.editKey "new key"
        expect(node.getNode('new key')).toBe nodeb

