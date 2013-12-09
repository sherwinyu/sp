#= require spec_helper
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
      expect(x.get("a.nodeType")).to.eql "number"
      expect(x.get("b.nodeType")).to.eql "string"

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
    expect(node.get('awake_at.nodeType')).to.eql "time"
    expect(node.get('awake_energy.nodeType')).to.eql "number"
    expect(node.get('outofbed_at.nodeType')).to.eql "time"
    expect(node.get('outofbed_energy.nodeType')).to.eql "number"
  it "has the proper values for time children", ->
    mmt = node.get("awake_at.nodeVal").mmt()
    expect(mmt.hours()).to.eql 8
    expect(mmt.minutes()).to.eql 43

    mmt = node.get("outofbed_at.nodeVal").mmt()
    expect(mmt.hours()).to.eql 9
    expect(mmt.minutes()).to.eql 50

describe "xHumon time", ->
  it "converts a HH:MM time", ->
    node = j2n("08:43")
    expect(node.get('nodeType')).to.eql "time"
    mmt = node.get('nodeVal').mmt()
    expect(mmt.hours()).to.eql 8
    expect(mmt.minutes()).to.eql 43

  it "works", ->
    node = j2n("2013 07 05")
    expect(node.get('nodeType')).to.eql "date"
    expect(j2n("8:43").get("nodeType")).to.eql "time"
    expect(j2n("2013 07 15").get("nodeType")).to.eql "date"

