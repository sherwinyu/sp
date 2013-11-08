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
