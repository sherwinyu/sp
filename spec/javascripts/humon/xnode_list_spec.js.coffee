describe 'xHumonValues list', ->
  json = [3, [1, 4], [1, [5]], [], 9]
  j2n = HumonUtils.json2node
  node = null
  node0 = null    # 3
  node1 = null    # [1, 4]
  node1_0 = null  # 1
  node1_1 = null   # 4
  node2 = null   #[1, [5] ]
  node2_0 = null   # 1
  node2_1 = null   # [5]
  node2_1_0 = null   # 5
  node3 = null # []
  node4 = null

  beforeEach ->
    node = j2n json
    node0 = node.get '0'
    node1 = node.get '1'
    node1_0 = node.get '1.0'
    node1_1 = node.get '1.1'
    node2 = node.get '2'
    node2_0 = node.get '2.0'
    node2_1 = node.get '2.1'
    node2_1_0 = node.get '2.1.0'
    node3 = node.get '3'
    node4 = node.get '4'

  describe 'flatten', ->
    it "returns an array with the proper nodes", ->
      expect(node1.flatten()).toEqual [node1, node1_0, node1_1]
    it "on an empty Humon.List node return just itself", ->
      expect(node3.flatten()).toEqual [node3]
    it "works on a large array", ->
      expect(node.flatten()).toEqual [node , node0 , node1 , node1_0 , node1_1 , node2 , node2_0 , node2_1 , node2_1_0 , node3]

  describe "nextNode", ->
    it "work for the root node", ->
      expect(node.nextNode()).toBe node0
    it "work when going up the tree to a sibling", ->
      expect(node1_0.nextNode()).toBe node1_1
      expect(node2_0.nextNode()).toBe node2_1
    it "work when diving into the tree", ->
      expect(node1_1.nextNode()).toBe node2
    it "returns null on a lone node", ->
      expect(j2n(1).nextNode()).toBe null
    it "works for an empty array", ->
      expect(node3.nextNode()).toBe node4
    ###
    it "work when diving nested into the tree", ->
      expect(nodec2.nextNode()).toBe nodec2nested
    it "work when node is empty collection", ->
      expect(noded.nextNode()).toBe nodee
    it "return null when there's nothing left to recurse", ->
      expect(nodee.nextNode()).toBe null
    it "return null on a lone node", ->
      hn = j2hn 1
      expect(hn.nextNode()).toBe null
    ###
