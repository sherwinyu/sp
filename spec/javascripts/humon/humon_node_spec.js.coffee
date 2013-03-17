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
  describe "modsngets", ->
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
