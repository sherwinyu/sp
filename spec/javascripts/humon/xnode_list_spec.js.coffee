#= require spec_helper

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
      expect(node1.flatten()).to.eql [node1, node1_0, node1_1]
    it "on an empty Humon.List node return just itself", ->
      expect(node3.flatten()).to.eql [node3]
    it "works on a large array", ->
      expect(node.flatten()).to.eql [node , node0 , node1 , node1_0 , node1_1 , node2 , node2_0 , node2_1 , node2_1_0 , node3, node4]

  describe "nextNode", ->
    it "work for the root node", ->
      expect(node.nextNode()).to.equal node0
    it "work when going up the tree to a sibling", ->
      expect(node1_0.nextNode()).to.equal node1_1
      expect(node2_0.nextNode()).to.equal node2_1
    it "work when diving into the tree", ->
      expect(node1_1.nextNode()).to.equal node2
    it "returns null on a lone node", ->
      expect(j2n(1).nextNode()).to.equal null
    it "works for an empty array", ->
      expect(node3.nextNode()).to.equal node4

  describe "prevNode", ->
    it "returns null on the root", ->
      expect(node.prevNode()).to.equal null
    it "returns the parent if its a first child", ->
      expect(node0.prevNode()).to.equal node
    it "returns the previous sibling if immediately available", ->
      expect(node2_1.prevNode()).to.equal node2_0
    it "goes in order", ->
      expect(node.prevNode()).to.equal null
      expect(node0.prevNode()).to.equal node
      expect(node1.prevNode()).to.equal node0
      expect(node1_0.prevNode()).to.equal node1
      expect(node1_1.prevNode()).to.equal node1_0
      expect(node2.prevNode()).to.equal node1_1
      expect(node2_0.prevNode()).to.equal node2
      expect(node2_1.prevNode()).to.equal node2_0
      expect(node2_1_0.prevNode()).to.equal node2_1
      expect(node3.prevNode()).to.equal node2_1_0
      expect(node4.prevNode()).to.equal node3
