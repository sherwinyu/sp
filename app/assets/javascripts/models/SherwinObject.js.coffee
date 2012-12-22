contentPropertyWillChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyWillChange(@, key)

contentPropertyDidChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyDidChange @, key

Sysys.EnumerableObjectViaObject = Ember.Object.extend Ember.Array,
  _magic: null
  _keys: null
  content: null

  nextObject: (indexNumber, previousObject, context) ->
    key = @get('_keys').objectAt(indexNumber)
    @get('content')?.get('key')

  length: (Ember.computed -> @get('_keys.length') ? 0 ).property()

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

  setUnknownProperty: (key, value) ->
    content = @get('content')

    Ember.assert(Ember.String.fmt("Cannot delegate set('%@', %@) to the 'content' property of object proxy %@: its 'content' is undefined.", [key, value, @]), content)

    unless content.hasOwnProperty key
      @get('_keys').pushObject key
    content.set('_key', key)
    return content.set(key, value)

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
