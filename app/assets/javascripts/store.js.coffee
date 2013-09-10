###
Sysys.Adapter = DS.RESTAdapter.extend

  # @overrides dirtyRecordsForAttributeChange
  # Calls super method (which just adds the record to the dirty set if newValue != oldValue)
  # In additon, checks for case when it's a humon node DS.attr.
  dirtyRecordsForAttributeChange: (dirtySet, record, attributeName, newValue, oldValue) ->
    @_super()
    # Need to do this to check cases when newValue == oldValue (by object reference comparison)
    if record.constructor?.metaForProperty(attributeName).type == 'humon'
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
