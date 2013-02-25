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
  describe "modifiers", ->
    node = nodea = nodeb = nodec = nodec0 = nodec1 = nodec2 = nodec2nested = null

    beforeEach ->
      hash = {a: 1, b: 2, c: [false, 'lalala', {nested: true}]}
      node = j2hn hash #TODO(syu): technically, shouldn't rely on this...
      nodea = node.get('nodeVal').findProperty('key', 'a').val
      nodeb = node.get('nodeVal').findProperty('key', 'b').val
      nodec = node.get('nodeVal').findProperty('key', 'c').val
      nodec0 = nodec.get('nodeVal.0')
      nodec1 = nodec.get('nodeVal.1')
      nodec2 = nodec.get('nodeVal.2')
      nodec2nested = nodec2.get('nodeVal').findProperty('key', 'nested').val

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