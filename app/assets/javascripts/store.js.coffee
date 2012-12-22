Sysys.Store = DS.Store.extend
  revision: 10,
  adapter: DS.RESTAdapter.create()

Sysys.store = new Sysys.Store

DS.JSONTransforms.object = 
  deserialize: (serialized) -> 
    if Em.isNone(serialized) then null else serialized

  serialize: (deserialized) ->
    if Em.isNone(deserialized) then null else deserialized

