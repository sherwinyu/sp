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
    awake_at: "8:43"
    awake_energy: 6
    outofbed_at: "9:50"
    outofbed_energy: 8
  node = null
  beforeEach ->
    node = j2n(json, type: Humon.Sleep)
  it "has the proper types for children nodes", ->
    expect(node.get('awake_at.nodeType')).toBe "time"
    expect(node.get('awake_energy.nodeType')).toBe "number"
    expect(node.get('outofbed_at.nodeType')).toBe "time"
    expect(node.get('outofbed_energy.nodeType')).toBe "number"
  it "has the proper values for time children", ->
    mmt = node.get("awake_at.nodeVal").mmt()
    expect(mmt.hours()).toBe 8
    expect(mmt.minutes()).toBe 43

    mmt = node.get("outofbed_at.nodeVal").mmt()
    expect(mmt.hours()).toBe 9
    expect(mmt.minutes()).toBe 50

describe "xHumon time", ->
  it "converts a HH:MM time", ->
    node = j2n("08:43")
    expect(node.get('nodeType')).toBe "time"
    mmt = node.get('nodeVal').mmt()
    expect(mmt.hours()).toBe 8
    expect(mmt.minutes()).toBe 43

  it "works", ->
    node = j2n("2013 07 05")
    expect(node.get('nodeType')).toBe "date"
    expect(j2n("8:43").get("nodeType")).toBe "time"
    expect(j2n("2013 07 15").get("nodeType")).toBe "date"

