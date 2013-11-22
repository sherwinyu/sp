describe "xHumonValues complex", ->
  Humon.ComplexSubClass = Humon.Complex.extend()
  Humon.ComplexSubClass.reopenClass
    childMetatemplates:
      a:
        name: "Number"
      b:
        name: "String"

  json = []
  j2n = HumonUtils.json2node
  describe "subclasses", ->
    it "properly converts a subclass", ->
      payload = a: "1234567", b: "1234567"
      x = j2n(payload, type: Humon.ComplexSubClass)
      expect(x.get("a.nodeType")).toBe "number"
      expect(x.get("b.nodeType")).toBe "string"




