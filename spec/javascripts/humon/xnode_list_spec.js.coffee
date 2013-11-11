describe 'xHumonValues list', ->
  json = [3, [1, 4], [1, [5]], []]
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

  describe 'flatten', ->
    it "returns an array with the proper nodes", ->
      expect(node1.flatten()).toEqual [node1, node1_0, node1_1]
    it "on an empty Humon.List node return just itself", ->
      expect(node3.flatten()).toEqual [node3]
    it "works on a large array", ->
      expect(node.flatten()).toEqual [node , node0 , node1 , node1_0 , node1_1 , node2 , node2_0 , node2_1 , node2_1_0 , node3]
