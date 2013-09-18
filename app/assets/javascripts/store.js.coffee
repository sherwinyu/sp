Sysys.ApplicationSerializer = DS.RESTSerializer.extend
  normalize: (type, hash, property) ->
    normalized = {}
    normalizedProp = null

    for prop of hash
      if prop.substr(-3) == '_id'
        # belongsTo relationships
        normalizedProp = prop.slice(0, -3)
      else if prop.substr(-4) == '_ids'
        # hasMany relationship
        normalizedProp = Ember.String.pluralize(prop.slice(0, -4))
      else
        # regualarAttribute
        normalizedProp = prop;
      normalizedProp = Ember.String.camelize(normalizedProp)
      normalized[normalizedProp] = hash[prop]

    return @_super(type, normalized, property)
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
