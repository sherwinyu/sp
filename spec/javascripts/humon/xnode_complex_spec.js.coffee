j2n = HumonUtils.json2node

describe "xHumonValues complex", ->
  Humon.ComplexSubClass = Humon.Complex.extend()
  Humon.ComplexSubClass.reopenClass
    childMetatemplates:
      a:
        name: "Number"
      b:
        name: "String"

  json = []
  describe "subclasses", ->
    it "properly converts a subclass", ->
      payload = a: "1234567", b: "1234567"
      x = j2n(payload, type: Humon.ComplexSubClass)
      expect(x.get("a.nodeType")).toBe "number"
      expect(x.get("b.nodeType")).toBe "string"

describe "xHumon sleep", ->
  json =
    awake_at: new Date(2013, 11, 24, 8, 30)
    awake_energy: 6
    outofbed_at: new Date(2013, 11, 24, 9, 30)
    outofbed_energy: 8
  node = null
  beforeEach ->
    node = j2n(json, type: Humon.Sleep)
  it "has the proper types for children nodes", ->
    expect(node.get('awake_at.nodeType')).toBe "date"
    expect(node.get('awake_energy.nodeType')).toBe "number"
    expect(node.get('outofbed_at.nodeType')).toBe "date"
    expect(node.get('outofbed_energy.nodeType')).toBe "number"

describe "xHumon time", ->
  json = "2013 08 15"
  node = null
  beforeEach ->
    node = j2n json
  it "doesnot convert a date", ->
    expect(node.get('nodeType')).toBe "date"
  it "converts a time", ->
    expect(node.get('nodeType')).toBe "date"
    expect(j2n("8:43").get("nodeType")).toBe "time"
  #     dates = ["2013 07 05", new Date(2013, 6, 5), "Fri Jul 5"]

