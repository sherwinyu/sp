shu = HumonUtils
describe 'xHumon Utils', ->
  describe 'json2node', ->
    json = null
    j2n = HumonUtils.json2node
    node = null

    describe "on list of lists", ->
      array = [1, 4, [1, 5, [3, 3], 6 ] ]

      beforeEach ->
        node = j2n array
      it "returns HumonNode wrapping nodeVals with lists", ->
        node0 = node.get('nodeVal.0')
        node1 = node.get('nodeVal.1')
        node2 = node.get('nodeVal.2')
        node2_0 = node2.get '0'
        node2_1 = node2.get '1'
        node2_2 = node2.get '2'
        node2_2_0 = node2_2.get '0'
        node2_2_1 = node2_2.get '1'
        node2_3 = node2.get '3'

        # check value links
        expect(node0.val()).toEqual 1
        expect(node1.val()).toEqual 4
        expect(node2.val()).toEqual [1, 5, [3, 3], 6]
        expect(node2_0.val()).toEqual 1
        expect(node2_1.val()).toEqual 5
        expect(node2_2.val()).toEqual [3, 3]
        expect(node2_2_0.val()).toEqual 3
        expect(node2_3.val()).toEqual 6

        # check parent links
        expect(node2_3.nodeParent).toBe node2
        expect(node2_2_1.nodeParent).toBe node2_2
        expect(node0.nodeParent).toBe node

    describe "on date", ->
      dates = ["2013 07 05", new Date(2013, 6, 5), "Fri Jul 5"]
      beforeEach ->
        node = j2n dates
      it "parses 2013 07 05", ->
        expect(node.get('nodeVal.0').val()).toEqual new Date(2013, 6, 5)
      it "parses Date objects", ->
        expect(node.get('nodeVal.1').val()).toEqual new Date(2013, 6, 5)
      it "Fri Jul 5 2013", ->
        expect(node.get('nodeVal.2').val()).toEqual new Date(2013, 6, 5)

    describe "on complex object", ->
      json_src = {a: 1, b: 2, c: [false, 'lalala', {nested: true}], d:[], e: {}}
      node = nodea = nodeb = nodec = nodec0 = nodec1 = nodec2 = nodec2nested = noded = nodee = null

      beforeEach ->
        node = j2n json_src
        nodea = node.get('a')
        nodeb = node.get('b')
        nodec = node.get('c')
        nodec0 = nodec.get('0')
        nodec1 = nodec.get('1')
        nodec2 = nodec.get('2')
        nodec2nested = nodec2.get('nested')
        noded = node.get('d')
        nodee = node.get('e')

      it "returns the correct objects", ->
        expect(node.val()).toEqual json_src
        expect(nodea.val()).toEqual 1
        expect(nodeb.val()).toEqual 2
        expect(nodeb.val()).toEqual 2
