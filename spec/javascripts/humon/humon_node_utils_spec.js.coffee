shu = Sysys.HumonUtils
describe 'HumonNode json2humon', ->
  json = null
  j2hn = shu.json2humonNode
  spyj2hn = null
  node = null

  beforeEach ->
    spyj2hn = sinon.spy Sysys.HumonUtils, "json2humonNode"


  afterEach ->
    spyj2hn.restore()

  describe "when called on flat list", ->
    array = [1, 4, 'sdf']

    beforeEach ->
      node = j2hn array


    it "should recurse for each element of the list", ->
      expect(spyj2hn).toHaveBeenCalledThrice()
      expect(spyj2hn).toHaveBeenCalledWithExactly 1, node
      expect(spyj2hn).toHaveBeenCalledWithExactly 4, node
      expect(spyj2hn).toHaveBeenCalledWithExactly 'sdf', node

    it "should return a HumonNode with containing a list of HumonNodes wrapping literals", ->
      expect(node.get 'nodeVal.0.nodeVal').toBe 1
      expect(node.get 'nodeVal.1.nodeVal').toBe 4
      expect(node.get 'nodeVal.2.nodeVal').toBe 'sdf'
      expect(node.get 'nodeType').toEqual 'list'

    it "should set up nodeParent relations", ->
      expect(node.get('nodeParent')).toBe null
      expect(node.get 'nodeVal.0.nodeParent').toBe node
      expect(node.get 'nodeVal.1.nodeParent').toBe node
      expect(node.get 'nodeVal.2.nodeParent').toBe node

    it "should work on different literal types", ->
      throw 'pending'
  
  describe "when called on flat hash", ->
    hash = {a: 1, b: 2, c: 3}

    beforeEach ->
      node = j2hn hash
    it "should recurse once for each k,v pair of hash", ->
      expect(spyj2hn).toHaveBeenCalledThrice()
      expect(spyj2hn).toHaveBeenCalledWith 1
      expect(spyj2hn).toHaveBeenCalledWith 2
      expect(spyj2hn).toHaveBeenCalledWith 3

    it "should return a HumonNode with a list of KVPs, each with a HumonNode wrapping a literal as a val", ->
      expect(node.get('nodeVal').findProperty('nodeKey', 'a').get('nodeVal')).toBe 1
      expect(node.get('nodeVal').findProperty('nodeKey', 'a').get('nodeVal')).toBe 1
      expect(node.get('nodeVal').findProperty('nodeKey', 'b').get('nodeVal')).toBe 2
      expect(node.get('nodeVal').findProperty('nodeKey', 'c').get('nodeVal')).toBe 3
      expect(node.get 'nodeType').toEqual 'hash'

    it "should set up nodeParent relations", ->
      expect(node.get('nodeParent')).toBe null
      expect(node.get('nodeVal').findProperty('nodeKey', 'a').get('nodeParent')).toBe node
      expect(node.get('nodeVal').findProperty('nodeKey', 'b').get('nodeParent')).toBe node
      expect(node.get('nodeVal').findProperty('nodeKey', 'c').get('nodeParent')).toBe node


  describe "when called on nested structure", ->
    hash = {a: 1, b: 2, c: [false, 'lalala', {nested: true}]}
    nodea = nodeb = nodec = nodec0 = nodec1 = nodec2 = nodec2nested = null

    beforeEach ->
      node = j2hn hash
      nodea = node.get('nodeVal').findProperty('nodeKey', 'a')
      nodeb = node.get('nodeVal').findProperty('nodeKey', 'b')
      nodec = node.get('nodeVal').findProperty('nodeKey', 'c')
      nodec0 = nodec.get('nodeVal.0')
      nodec1 = nodec.get('nodeVal.1')
      nodec2 = nodec.get('nodeVal.2')
      nodec2nested = nodec2.get('nodeVal').findProperty('nodeKey', 'nested')

    it "should recurse once for each k,v pair of hash", ->
      expect(spyj2hn).toHaveBeenCalledWith 1
      expect(spyj2hn).toHaveBeenCalledWith 2
      expect(spyj2hn).toHaveBeenCalledWith [false, 'lalala', {nested: true}]
      expect(spyj2hn).toHaveBeenCalledWith false
      expect(spyj2hn).toHaveBeenCalledWith 'lalala'
      expect(spyj2hn).toHaveBeenCalledWith {nested: true}
      expect(spyj2hn).toHaveBeenCalledWith true

    it "should return a HumonNode the correctly nested HumonNode structure", ->
      expect(node.get 'nodeType').toBe 'hash'
      expect(node.get 'nodeVal').toEqual jasmine.any(Array)

      expect(nodea.get 'nodeType').toBe 'literal'
      expect(nodea.get 'nodeVal').toBe 1

      expect(nodeb.get 'nodeType').toBe 'literal'
      expect(nodeb.get 'nodeVal').toBe 2

      expect(nodec.get 'nodeType').toBe 'list'
      expect(nodec.get 'nodeVal').toEqual jasmine.any(Array)

      expect(nodec0.get 'nodeType').toBe 'literal'
      expect(nodec0.get 'nodeVal').toBe false

      expect(nodec1.get 'nodeType').toBe 'literal'
      expect(nodec1.get 'nodeVal').toBe 'lalala'

      expect(nodec2.get 'nodeType').toBe 'hash'
      expect(nodec2.get 'nodeVal').toEqual jasmine.any(Array)

      expect(nodec2nested.get 'nodeType').toBe 'literal'
      expect(nodec2nested.get 'nodeVal').toBe true

    it "should set up nodeParent relations", ->
      expect(node.get('nodeParent')).toBe null
      expect(nodea.get 'nodeParent').toBe node
      expect(nodeb.get 'nodeParent').toBe node
      expect(nodec.get 'nodeParent').toBe node
      expect(nodec0.get 'nodeParent').toBe nodec
      expect(nodec1.get 'nodeParent').toBe nodec
      expect(nodec2.get 'nodeParent').toBe nodec
      expect(nodec2nested.get 'nodeParent').toBe nodec2

  describe "when called on literal", ->
    literal = 5

    beforeEach ->
      node = j2hn literal

    it "should not recurse", ->
      expect(spyj2hn).not.toHaveBeenCalled()
    it "should return a HumonNode wrapping the literal", ->
      expect(node.get('nodeVal')).toBe 5
      expect(node.get('nodeType')).toBe 'literal'

    it "should be parentless", ->
      expect(node.get('nodeParent')).toBe null

describe "type checkers", ->
  hash1 = {a: 6}
  hash2 = {}
  hash3 = Ember.Object.create()
  arr1 = [1, 2, 3]
  arr2 = []
  arr3 = Em.A([0])
  bool = false
  num = 3.14
  str = "111"

  describe "isHash", ->
    it "should respond true for an objective",  ->
      expect(shu.isHash(hash1)).toBe true
      expect(shu.isHash(hash2)).toBe true
      expect(shu.isHash(hash3)).toBe true
    it "should respond false for arrays", ->
      expect(shu.isHash(arr1)).toBe false
      expect(shu.isHash(arr2)).toBe false
      expect(shu.isHash(arr3)).toBe false
    it "should respond false for literals", ->
      expect(shu.isHash(bool)).toBe false
      expect(shu.isHash(num)).toBe false
      expect(shu.isHash(str)).toBe false

  describe "isList", ->
    it "should respond false for arrrays", ->
      expect(shu.isList(hash1)).toBe false
      expect(shu.isList(hash2)).toBe false
      expect(shu.isList(hash3)).toBe false
    it "should respond true for arrrays", ->
      expect(shu.isList(arr1)).toBe true
      expect(shu.isList(arr2)).toBe true
      expect(shu.isList(arr3)).toBe true
    it "should respond false for arrrays", ->
      expect(shu.isList(bool)).toBe false
      expect(shu.isList(num)).toBe false
      expect(shu.isList(str)).toBe false

  describe "isLiteral", ->
    it "should respond false for arrrays", ->
      expect(shu.isLiteral(hash1)).toBe false
      expect(shu.isLiteral(hash2)).toBe false
      expect(shu.isLiteral(hash3)).toBe false
    it "should respond false for arrrays", ->
      expect(shu.isLiteral(arr1)).toBe false
      expect(shu.isLiteral(arr2)).toBe false
      expect(shu.isLiteral(arr3)).toBe false
    it "should respond true for literals", ->
      expect(shu.isLiteral(bool)).toBe true
      expect(shu.isLiteral(num)).toBe true
      expect(shu.isLiteral(str)).toBe true
    it "should fail for date objects", ->
      expect(-> shu.isLiteral(new Date())).toThrow()
