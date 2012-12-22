Sysys.EnumerableObjectViaObject = Ember.Object.extend Ember.Array,
  _magic: null
  _keys: null
  content: null

  nextObject: (indexNumber, previousObject, context) ->
    key = @get('_keys').objectAt(indexNumber)
    @get('content')?.get('key')

  length: (Ember.computed -> @get('_keys.length') ? 0 ).property()

  parseFromHash: (object) ->
    yearsOld = max: 10, ida: 9, tim: 11

    ages = for child, age of yearsOld
      "#{child} is #{age}"

    ret = for own k, v of object
      v
      
      

    ret


  init: ->
    @set('content', Ember.Object.create())
    @set('_keys', [])
    for k, v of @get('_magic')
      @set(k, v)
    debugger
    @_super

    # _getValByKey: (key) ->
    
  objectAt: (idx) ->
    unless 0 <= idx < @get('_keys.length')
      return undefined
    key = @get('_keys')[idx]
    @get(key)

  setUnknownProperty: (key, value) ->
    content = @get('content')

    Ember.assert(Ember.String.fmt("Cannot delegate set('%@', %@) to the 'content' property of object proxy %@: its 'content' is undefined.", [key, value, @]), content)

    unless content.hasOwnProperty key
      @get('_keys').pushObject key
    return content.set(key, value)

  unknownProperty: (key) ->
    content = @get('content')
    if content?.hasOwnProperty key
      content.get key
    else
      undefined



    # recursive_init(@_magic)
    
