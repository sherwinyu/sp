Sysys.Store = DS.Store.extend
  revision: 10,
  adapter: DS.RESTAdapter.create()

Sysys.store = new Sysys.Store

DS.JSONTransforms.object = 
  deserialize: (serialized) -> 
    if Em.isNone(serialized) then null else Sysys.JSONWrapper.recursiveDeserialize(serialized)

  serialize: (deserialized) ->
    if Em.isNone(deserialized) then null else deserialized

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
