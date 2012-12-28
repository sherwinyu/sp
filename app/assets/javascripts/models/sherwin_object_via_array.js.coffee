willChange = (content, contentIndex) ->
  index = parseInt contentIndex.slice 8
  key = @getKeyByVal(@_keys, index)
  Ember.propertyWillChange(@,  key)

didChange = (content, contentIndex) ->
  index = parseInt contentIndex.slice 8
  key = @getKeyByVal(@_keys, index)
  Ember.propertyDidChange(@,  key)


Sysys.EnumerableObjectViaArray = Ember.ArrayProxy.extend
  _keys: null
  content: null
  _magic: null
  isHash: true

  keys: (-> 
    Object.keys(@_keys)
  ).property('_keys')

  getKeyByVal: (obj, val)->
    for own k,v of obj
      if v == val
        return k
    undefined

  setUnknownProperty: (key, val) ->
    unless @get('content')?
      @set('content', [])
    unless @get('_keys')?
      @set('_keys', Ember.Object.create())
    _keys = @get('_keys')
    content = @get('content')

    if _keys?.hasOwnProperty key # replace
      index = @get('_keys').get(key)
      # @replace(index, 1, val)
      content.set("#{index}", val)
    else
      index = @get('length')
      content.pushObject(val)
      _keys.set(key, index)
    @

  unknownProperty: (key) ->
    _keys = @get('_keys')
    content = @get('content')
    if _keys?.hasOwnProperty key
      index = _keys.get(key)
      Ember.assert("index must be numeric", typeof index == 'number' )
      content.get index
    else
      undefined

  init: ->
    @_super()
    unless @get('content')?
      @set('content', [])
    unless @get('_keys')?
      @set('_keys', Ember.Object.create())
    for k, v of @get('_magic')
      @set(k, v)

  willWatchProperty: (key) ->
    root  = key.split ".", 1
    path = key.substring root.length
    index = @_keys.get(root)
    indexedPath = "content.#{index}" + path

    Ember.addBeforeObserver(@, indexedPath, null, willChange)
    Ember.addObserver(@, indexedPath, null, didChange)
    #Ember.addBeforeObserver(@, contentKey, null, didChange)

  didUnwatchProperty: (key) ->
    root  = key.split ".", 1
    path = key.substring root.length
    index = @_keys.get(root)
    indexedPath = "content.#{index}" + path

    Ember.removeBeforeObserver @, indexedPath, null, willChange
    Ember.removeObserver @, indexedPath, null, didChange

