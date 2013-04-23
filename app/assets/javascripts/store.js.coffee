Sysys.Adapter = DS.RESTAdapter.extend
  # @overrides dirtyRecordsForAttributeChange
  dirtyRecordsForAttributeChange: (dirtySet, record, attributeName, newValue, oldValue) ->
    @_super()
    # Need to do this to check cases when newValue == oldValue (by object reference comparison)
    if record.constructor?.metaForProperty(attributeName).type == 'humon'
      # and newValue == oldValue
      @dirtyRecordsForRecordChange(dirtySet, record)

Sysys.Adapter.registerTransform 'humon',
  serialize: (humonNode) ->
    humonNode.get('json')
  deserialize: (json) ->
    Sysys.j2hn json

Sysys.Store = DS.Store.extend
  revision: 12,
  adapter: Sysys.Adapter.create()




###
DS.JSONTransforms.object =
  deserialize: (serialized) ->
    serialized ?= {}
    Sysys.JSONWrapper.recursiveDeserialize(serialized)
    #if Em.isNone(serialized) then Ember.Object.create() else Sysys.JSONWrapper.recursiveDeserialize(serialized)

  serialize: (deserialized) ->
    ret = if Em.isNone(deserialized) then null else Sysys.JSONWrapper.recursiveSerialize deserialized
    ret

Sysys.JSONWrapper =
  isHash: (val) ->
    val? and (typeof val is 'object') and !(val instanceof Array)
  isArray: (val) ->
    val? and typeof val is 'object' and val instanceof Array and typeof val.length is 'number'
  isPlain: (val) ->
    val? and typeof val isnt 'object'

  recursiveDeserialize: (val) ->
    if Sysys.JSONWrapper.isPlain val
      return val
    if Sysys.JSONWrapper.isHash val
      # a = Sysys.EnumerableObjectViaArray.create()
      a = Sysys.EnumerableObjectViaObject.create()
      for own k, v of val
        a.set(k, Sysys.JSONWrapper.recursiveDeserialize(v))
      return a
    if Sysys.JSONWrapper.isArray val
      a = []
      for v in val
        a.pushObject Sysys.JSONWrapper.recursiveDeserialize(v)
      return a
    throw new Error("this shoud never happen")

  recursiveSerialize: (val) ->
    if Sysys.JSONWrapper.isPlain val
      return val
    if val.isHash and val instanceof Sysys.EnumerableObjectViaObject
      ret = {}
      for key in val._keys
        ret[key] = Sysys.JSONWrapper.recursiveSerialize val.get(key)
      return ret
    if Sysys.JSONWrapper.isArray val
      ret = []
      for ele in val
        ret.pushObject Sysys.JSONWrapper.recursiveSerialize ele
      return ret
    throw new Error("this shoud never happen")
###
