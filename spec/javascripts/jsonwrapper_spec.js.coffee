describe "JSONWrapper", ->
  beforeEach ->
    @jw = Sysys.JSONWrapper
  describe "type checkers", ->
    hash1 = {a: 5}
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
        expect(@jw.isHash(hash1)).toBe true
        expect(@jw.isHash(hash2)).toBe true
        expect(@jw.isHash(hash3)).toBe true
      it "should respond false for arrays", ->
        expect(@jw.isHash(arr1)).toBe false
        expect(@jw.isHash(arr2)).toBe false
        expect(@jw.isHash(arr3)).toBe false
      it "should respond false for literals", ->
        expect(@jw.isHash(bool)).toBe false
        expect(@jw.isHash(num)).toBe false
        expect(@jw.isHash(str)).toBe false

    describe "isArray", ->
      it "should respond false for arrrays", ->
        expect(@jw.isArray(hash1)).toBe false
        expect(@jw.isArray(hash2)).toBe false
        expect(@jw.isArray(hash3)).toBe false
      it "should respond true for arrrays", ->
        expect(@jw.isArray(arr1)).toBe true
        expect(@jw.isArray(arr2)).toBe true
        expect(@jw.isArray(arr3)).toBe true
      it "should respond false for arrrays", ->
        expect(@jw.isArray(bool)).toBe false
        expect(@jw.isArray(num)).toBe false
        expect(@jw.isArray(str)).toBe false

    describe "literal", ->
      it "should respond false for arrrays", ->
        expect(@jw.isPlain(hash1)).toBe false
        expect(@jw.isPlain(hash2)).toBe false
        expect(@jw.isPlain(hash3)).toBe false
      it "should respond false for arrrays", ->
        expect(@jw.isPlain(arr1)).toBe false
        expect(@jw.isPlain(arr2)).toBe false
        expect(@jw.isPlain(arr3)).toBe false
      it "should respond true for literals", ->
        expect(@jw.isPlain(bool)).toBe true
        expect(@jw.isPlain(num)).toBe true
        expect(@jw.isPlain(str)).toBe true

  xdescribe "recursiveDeserialize", ->
    rd = Sysys.JSONWrapper.recursiveDeserialize

    beforeEach ->
      @spyRd = sinon.spy(Sysys.JSONWrapper, "recursiveDeserialize")

    afterEach ->
      @spyRd.restore()

    describe "when called on literal values", ->
      literal = 5

      beforeEach ->
        @ret = rd(literal)

      it "should not recurse", ->
        expect(@spyRd).not.toHaveBeenCalled()
      it "should return the literal", ->
        expect(@ret).toBe(literal)

    describe "when called on flat array", ->
      array = [1, 4, 'sdf']

      beforeEach ->
        @ret = rd(array)
      it "should recurse for each element of the array", ->
        expect(@spyRd).toHaveBeenCalledThrice()
        expect(@spyRd).toHaveBeenCalledWith 1
        expect(@spyRd).toHaveBeenCalledWith 4 
        expect(@spyRd).toHaveBeenCalledWith 'sdf'
      it "should return the correct array with get paths", ->
        expect(@ret).toEqual [1, 4, 'sdf']
        expect(@ret.get('0')).toEqual 1
        expect(@ret.get('1')).toEqual 4
        expect(@ret.get('2')).toEqual 'sdf'
    
    describe "when called on flat hash", ->
      hash = {a: 1, b:2, c: 3 }

      beforeEach ->
        @ret = rd(hash)
      it "should recurse once for each k,v pair of hash", ->
        expect(@spyRd).toHaveBeenCalledThrice()
        expect(@spyRd).toHaveBeenCalledWith 1
        expect(@spyRd).toHaveBeenCalledWith 2 
        expect(@spyRd).toHaveBeenCalledWith 3
      it "should return the correct hash with bindings", ->
        ret = @ret
        # TODO(syu): add a equals comparison
        # expect(@ret).toEqual Sysys.EnumerableObjectViaObject.create _magic: hash
        expect(@ret.get('a')).toBe 1
        expect(@ret.get('b')).toBe 2
        expect(@ret.get('c')).toBe 3

    describe "when called on nested arrays", ->
      array = [4, ["a", "b", "c"], 5]

      beforeEach ->
        @ret = rd(array)

      it "should recurse for each element of the array", ->
        spyRdCalledWith = @spyRd.args
        expect(@spyRd).toHaveBeenCalledWith 4
        expect(@spyRd).toHaveBeenCalledWith ["a", "b", "c"]
        expect(@spyRd).toHaveBeenCalledWith "a"
        expect(@spyRd).toHaveBeenCalledWith "b"
        expect(@spyRd).toHaveBeenCalledWith "c"
        expect(@spyRd).toHaveBeenCalledWith 5

      it "should return the correct array with get paths", ->
        expect(@ret).toEqual [4, ["a", "b", "c"], 5]
        expect(@ret.get('0')).toEqual 4
        expect(@ret.get('1')).toEqual ["a", "b", "c"]
        expect(@ret.get('1.0')).toEqual "a"
        expect(@ret.get('1.1')).toEqual "b"
        expect(@ret.get('1.2')).toEqual "c"
        expect(@ret.get('2')).toEqual 5

      it "should return bindable arrays", ->
          newClass = Ember.Object.extend
            valBinding: 'target.0'
            nestedValBinding: 'target.1.2'
            target: @ret
          otherObject = window.otherObject = newClass.create()
          Ember.run =>
            otherObject.set('val', 555)
            otherObject.set('nestedVal', 666)
          expect(@ret.get('0')).toEqual 555
          expect(@ret.get('1.2')).toEqual 666
          Ember.run =>
            @ret.set('0', [1,2,3,4])
            @ret.set('1.2', "new value")
          expect(otherObject.get('val')).toEqual [1,2,3,4]
          expect(otherObject.get('nestedVal')).toEqual "new value"

    describe "when called on nested hash", ->
      hash = {a: 1, b: {x: 'nestedVal'}, c: 22 }

      beforeEach ->
        @ret = rd(hash)

      it "should recurse for all nested values", ->
        expect(@spyRd).toHaveBeenCalledWith 1
        expect(@spyRd).toHaveBeenCalledWith {x: 'nestedVal'} 
        expect(@spyRd).toHaveBeenCalledWith 'nestedVal'
        expect(@spyRd).toHaveBeenCalledWith 22

      it "should return the correctly nested EnumerableObject get paths", ->
        ret = @ret
        # TODO(syu): add a equals comparison
        # expect(@ret).toEqual Sysys.EnumerableObjectViaObject.create _magic: hash
        expect(@ret.get('a')).toBe 1
        check = @ret.get('b') instanceof Sysys.EnumerableObjectViaObject || @ret.get('b') instanceof Sysys.EnumerableObjectViaArray 
        expect(check).toBeTruthy()
        expect(@ret.get('b.x')).toBe 'nestedVal'
        expect(@ret.get('c')).toBe 22

      it "should return an EnumerableObject that respects bindings", ->
          newClass = Ember.Object.extend
            valBinding: 'target.a'
            nestedValBinding: 'target.b.x'
            target: @ret
          otherObject = window.otherObject = newClass.create()
          Ember.run =>
            otherObject.set('val', 555)
            otherObject.set('nestedVal', 666)
          expect(@ret.get('a')).toEqual 555
          expect(@ret.get('b.x')).toEqual 666
          Ember.run =>
            @ret.set('a', [1,2,3,4])
            @ret.set('b.x', "new value")
          expect(otherObject.get('val')).toEqual [1,2,3,4]
          expect(otherObject.get('nestedVal')).toEqual "new value"

    describe "when called on nested", ->
      beforeEach ->
        @serialized = [
          {
          "array":[1,2,3],
          "object":{"a": true,"b": false},
          "scalar":"mountains",
          },
          [55, 66, 77]
        ]
        @ret = rd(@serialized)
      it "should recurse correctly", ->
        expect(@spyRd).toHaveBeenCalledWith [1,2,3]
        expect(@spyRd).toHaveBeenCalledWith 1
        expect(@spyRd).toHaveBeenCalledWith 2
        expect(@spyRd).toHaveBeenCalledWith 3
        expect(@spyRd).toHaveBeenCalledWith {a: true, b: false}
        expect(@spyRd).toHaveBeenCalledWith true
        expect(@spyRd).toHaveBeenCalledWith false
        expect(@spyRd).toHaveBeenCalledWith "mountains"
        expect(@spyRd).toHaveBeenCalledWith [55, 66, 77]
        expect(@spyRd).toHaveBeenCalledWith  55
        expect(@spyRd).toHaveBeenCalledWith  66
        expect(@spyRd).toHaveBeenCalledWith  77
      it "should set up get paths correctly", ->
        expect(@ret.get('0.array')).toEqual [1,2,3]
        expect(@ret.get('0.array.0')).toEqual 1
        expect(@ret.get('0.array.1')).toEqual 2
        expect(@ret.get('0.array.2')).toEqual 3
        # TODO(syu): add a equals comparison for objects
        expect(@ret.get('0.object.a')).toEqual true
        expect(@ret.get('0.object.b')).toEqual false
        expect(@ret.get('0.scalar')).toEqual "mountains"
        expect(@ret.get('1.0')).toEqual 55
        expect(@ret.get('1.1')).toEqual 66
        expect(@ret.get('1.2')).toEqual 77

      it "should set up bindings properly", ->
          newClass = Ember.Object.extend
            arrayBinding: 'target.array'
            array0Binding: 'target.array.0'
            objectBinding: 'target.object'
            objectBBinding: 'target.object.b'
            scalarBinding: 'target.scalar'
            target: @ret.get('0')
          otherObject = window.otherObject = newClass.create()
          Ember.run =>
            otherObject.set('array', [0, 8, 7])
            otherObject.set('array0', 9)
            otherObject.set('objectB', 555)
            otherObject.set('scalar', 'new scalar')
          expect(@ret.get('0.array')).toEqual [9, 8, 7]
          expect(@ret.get('0.array.0')).toEqual 9
          expect(@ret.get('0.object.b')).toEqual 555
          expect(@ret.get('0.scalar')).toEqual 'new scalar'

          Ember.run =>
            @ret.set('0.array', [1,2,3,4])
            @ret.set('0.object.b', 554)
            @ret.set('0.scalar', 'old scalar')
          expect(otherObject.get('array')).toEqual [1,2,3,4]
          expect(otherObject.get('object.b')).toEqual 554
          expect(otherObject.get('objectB')).toEqual 554
          expect(otherObject.get('scalar')).toEqual 'old scalar'


  describe "recursiveSerialize", ->
    rs = Sysys.JSONWrapper.recursiveSerialize

    beforeEach ->
      @spyRs = sinon.spy(Sysys.JSONWrapper, "recursiveSerialize")
    afterEach ->
      Sysys.JSONWrapper.recursiveSerialize.restore()

    describe "when called on literal", ->
      describe "num", ->
        literal = 5
        beforeEach ->
          @ret = rs(literal)
        it "should not recurse", ->
          expect(@spyRs).not.toHaveBeenCalled()
        it "should return the literal", ->
          expect(@ret).toBe(literal)

      describe "boolean", ->
        literal = true
        beforeEach ->
          @ret = rs(literal)
        it "should not recurse", ->
          expect(@spyRs).not.toHaveBeenCalled()
        it "should return the literal", ->
          expect(@ret).toBe(literal)

      describe "string", ->
        literal = "i am a string"
        beforeEach ->
          @ret = rs(literal)
        it "should not recurse", ->
          expect(@spyRs).not.toHaveBeenCalled()
        it "should return the literal", ->
          expect(@ret).toBe(literal)

    describe "when called on flat array", ->
    describe "when called on flat array", ->
    describe "when called on EnumerableObjectViaObject", ->
    xdescribe "when called on EnumerableObjectViaArray", ->
      
    
