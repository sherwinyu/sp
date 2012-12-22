describe "sherwin object", ->
  beforeEach ->
    args = 
      a: 1
      b: 2
      c: 3
      d: [1, 2, 3]
      f: {deeply: 10, nested: 20}
    @sherwinObject = Sysys.EnumerableObjectViaObject.create(_magic: args)
    
  afterEach ->
    # @sherwinObject.destroy()
    # @sherwinObject = null


  describe "on create", ->
    it "should get property values", ->
      expect(@sherwinObject.get('a')).toEqual 1
      expect(@sherwinObject.get('b')).toEqual 2
      expect(@sherwinObject.get('c')).toEqual 3

    it "should get array values", ->
      expect(@sherwinObject.get('d')).toEqual [1, 2, 3]

    it "should have the proper initial keys", ->
      expect(@sherwinObject.get('_keys')).toEqual ['a', 'b', 'c', 'd', 'f']

    it "should have the proper length", ->
      expect(@sherwinObject.get('length')).toEqual 5

  it "should be able to get deeply nested attributes", ->
    expect(@sherwinObject.get('f.deeply')).toEqual 10
    expect(@sherwinObject.get('f.nested')).toEqual 20

  it "should be able to get array objects", ->
    expect(@sherwinObject.get('d.0')).toEqual 1
    expect(@sherwinObject.get('d.1')).toEqual 2
  
  describe "set", ->
    it "when modifying existing values should not modify keys", ->
      keysPushObject = sinon.spy(@sherwinObject.get('_keys'), 'pushObject')
      @sherwinObject.set('a', 'new value')
      expect(keysPushObject).not.toHaveBeenCalled()
      expect(@sherwinObject.get('a')).toEqual 'new value'
      keysPushObject.restore()

    it "when setting unknown value should add to keys", ->
      keysPushObject = sinon.spy(@sherwinObject.get('_keys'), 'pushObject')
      @sherwinObject.set('newKey', 'new value')
      expect(keysPushObject).toHaveBeenCalledWith('newKey')
      expect(@sherwinObject.get('newKey')).toEqual 'new value'
      keysPushObject.restore()

  describe "bindings", ->
    it "should work in another object", ->
      newClass = Ember.Object.extend
        a: 5
        bBinding: 'sherwin.a'
        sherwin: @sherwinObject
      otherObject = window.otherObject = newClass.create()
      Ember.run =>
        otherObject.set('b', 55)
      expect(@sherwinObject.get('a')).toEqual 55
      Ember.run =>
        @sherwinObject.set('a', [1,2,3,4])
      expect(otherObject.get('b')).toEqual [1,2,3,4]
      expect(otherObject.get('b.0')).toEqual 1
