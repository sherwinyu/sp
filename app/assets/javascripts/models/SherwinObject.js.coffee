contentPropertyWillChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyWillChange(@, key)

contentPropertyDidChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyDidChange @, key

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

Sysys.EnumerableObjectViaObject = Ember.Object.extend Ember.Array,
  _magic: null
  _keys: null
  content: null

  isHash: true

  nextObject: (indexNumber, previousObject, context) ->
    key = @get('_keys').objectAt(indexNumber)
    @get('content')?.get('key')

  length: (Ember.computed -> @get('_keys.length') ? 0 ).property("_keys.@each")

  parseFromHash: (object) ->
    ret = for own k, v of object
      v
    ret

  init: ->
    @set('content', Ember.Object.create())
    @set('_keys', [])
    for k, v of @get('_magic')
      @set(k, v)
    @_super

  objectAt: (idx) ->
    unless 0 <= idx < @get('_keys.length')
      return undefined
    key = @get('_keys')[idx]
    @get(key)

    ###
  addArrayObserver: (target, opts) ->

var willChange = (opts && opts.willChange) || 'arrayWillChange',
        didChange  = (opts && opts.didChange) || 'arrayDidChange';

    var hasObservers = get(this, 'hasArrayObservers');
    if (!hasObservers) Ember.propertyWillChange(this, 'hasArrayObservers');
    Ember.addListener(this, '@array:before', target, willChange);
    Ember.addListener(this, '@array:change', target, didChange);
    if (!hasObservers) Ember.propertyDidChange(this, 'hasArrayObservers');
    return this;
    ###
  pushObj: (key, val) ->
    @arrayContentWillChange(@get('length'), 0, 1)
    @get('_keys').pushObject key
    @get('content').set(key, val)
    # @arrayContentDidChange(@get('length') - 1,
    
  _updateObj: (key, val) ->
    @arrayContentWillChange(@get('_keys').indexOf(key), 0, 0)
    @get('content').set(key, val)

  setUnknownProperty: (key, val) ->
    content = @get('content') 

    Ember.assert(Ember.String.fmt("Cannot delegate set('%@', %@) to the 'content' property of object proxy %@: its 'content' is undefined.", [key, val, @]), content)

    if content.hasOwnProperty key
      @_updateObj(key, val)
    else
      @pushObj(key, val)
    ###
    unless content.hasOwnProperty key
      @get('_keys').pushObject key
    content.set(key, value)
    ###
    # content.get(key).set('_key', key)
    #return content.get(key)

  unknownProperty: (key) ->
    content = @get('content')
    if content?.hasOwnProperty key
      content.get key
    else
      undefined

  willWatchProperty: (key) ->
    contentKey = 'content.' + key
    Ember.addBeforeObserver(@, contentKey, null, contentPropertyWillChange)
    Ember.addObserver(this, contentKey, null, contentPropertyDidChange)

  didUnwatchProperty: (key) ->
    contentKey = 'content.' + key
    Ember.removeBeforeObserver @, contentKey, null, contentPropertyWillChange
    Ember.removeObserver @, contentKey, null, contentPropertyWillChange
