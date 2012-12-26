debugger
describe "sherwin object via array", ->
  beforeEach ->
    args = 
      a: 1
      b: 2
      c: 3
      d: [1, 2, 3]
      f: {deeply: 10, nested: 20}


    @sherwinObject = Sysys.EnumerableObjectViaArray.create(_magic: args)
    
  afterEach ->
    # @sherwinObject.destroy()
    # @sherwinObject = null
    
  describe "getKeyByVal", ->
    describe "on vanilla JS objects", ->
      it "returns a key when the val is present", ->
        obj = {a: 1, b: 2, c: 'lala'}
        expect(@sherwinObject.getKeyByVal(obj, 1)).toEqual 'a'
        expect(@sherwinObject.getKeyByVal(obj, 2)).toEqual 'b'
        expect(@sherwinObject.getKeyByVal(obj, 'lala')).toEqual 'c'
        expect(@sherwinObject.getKeyByVal(obj, 'nothere')).toEqual undefined

    describe "on Ember.Objects", ->
      it "returns a key when the val is present", ->
        obj = Ember.Object.create()
        obj.set('a', 1)
        obj.set('b', 2)
        obj.set('c', 'lala')
        expect(@sherwinObject.getKeyByVal(obj, 1)).toEqual 'a'
        expect(@sherwinObject.getKeyByVal(obj, 2)).toEqual 'b'
        expect(@sherwinObject.getKeyByVal(obj, 'lala')).toEqual 'c'
        expect(@sherwinObject.getKeyByVal(obj, 'nothere')).toEqual undefined
      
  describe "interface", ->
    describe "get", ->
      it "should be able to get direct attributes", ->
        expect(@sherwinObject.get('a')).toEqual 1
        expect(@sherwinObject.get('b')).toEqual 2

      it "should be able to get deeply nested attributes", ->
        expect(@sherwinObject.get('f.deeply')).toEqual 10
        expect(@sherwinObject.get('f.nested')).toEqual 20

      it "should be able to get array objects", ->
        expect(@sherwinObject.get('d.0')).toEqual 1
        expect(@sherwinObject.get('d.1')).toEqual 2
    describe "set", ->
      describe "set", ->
        it "when modifying existing values should not modify keys", ->
          keysSet = sinon.spy(@sherwinObject.get('_keys'), 'set')
          @sherwinObject.set('a', 'new value')
          expect(keysSet).not.toHaveBeenCalled()
          expect(@sherwinObject.get('a')).toEqual 'new value'
          keysSet.restore()

        it "when setting unknown value should add to keys", ->
          keysSet = sinon.spy(@sherwinObject.get('_keys'), 'set')
          @sherwinObject.set('newKey', 'new value')
          expect(keysSet).toHaveBeenCalledWith('newKey')
          expect(@sherwinObject.get('newKey')).toEqual 'new value'
          keysSet.restore()

    describe "replace", ->

    describe "length", ->
      it "should have the proper length", ->
        expect(@sherwinObject.get('length')).toEqual 5

    describe "nextObject", ->

    describe "objectAt", ->

  describe "on create", ->
    it "should get property values", ->
      expect(@sherwinObject.get('a')).toEqual 1
      expect(@sherwinObject.get('b')).toEqual 2
      expect(@sherwinObject.get('c')).toEqual 3

    it "should get array values", ->
      expect(@sherwinObject.get('d')).toEqual [1, 2, 3]

    it "should have the proper initial keys", ->
      
      expect(@sherwinObject.get('keys')).toEqual ['a', 'b', 'c', 'd', 'f']

  describe "bindings", ->
    it "should work in another object", ->
      newClass = Ember.Object.extend
        aBinding: 'sherwin.a'
        sherwin: @sherwinObject
      otherObject = window.otherObject = newClass.create()
      expect(otherObject.get('a')) .toEqual 1
      Ember.run =>
        otherObject.set('a', 55)
      expect(@sherwinObject.get('a')).toEqual 55
      Ember.run =>
        @sherwinObject.set('a', [1,2,3,4])
      expect(otherObject.get('a')).toEqual [1,2,3,4]
      expect(otherObject.get('a.0')).toEqual 1
