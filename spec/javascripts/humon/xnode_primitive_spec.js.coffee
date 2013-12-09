#= require spec_helper
describe 'xHumonValues primitive', ->
  json = [31415, "2013-03-02", false, null]
  j2n = HumonUtils.json2node
  node = null
  node0 = null
  node1 = null
  node2 = null
  node3 = null
  beforeEach ->
    node = j2n json
    node0 = node.get('0')
    node1 = node.get('1')
    node2 = node.get('2')
    node3 = node.get('3')

  describe 'flatten', ->
    it "returns an array with just its node", ->
      expect(node0.flatten()).to.eql [node0]
      expect(node1.flatten()).to.eql [node1]
      expect(node2.flatten()).to.eql [node2]
      expect(node3.flatten()).to.eql [node3]
