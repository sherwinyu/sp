Sysys.ApplicationSerializer = DS.RESTSerializer.extend

  # to convert camelcased js attributes to
  # underscored attributes in the request to server
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

  # to convert camelcased js attributes to
  # underscored attributes in the request to server
  serializeAttribute: (record, json, key, attribute) ->
    attrs = @get 'attrs'
    value = record.get(key)
    type = attribute.type

    if type
      transform = @transformFor(type)
      value = transform.serialize(value)

    # if provided, use the mapping provided by `attrs` in
    # the serializer; otherwise, attempt to decamelize
    key = attrs && attrs[key] || Ember.String.decamelize(key)

    json[key] = value

hasValue = (record, key) ->
  record._attributes.hasOwnProperty(key) or record._inFlightAttributes.hasOwnProperty(key) or record._data.hasOwnProperty(key)

getValue = (record, key) ->
  if record._attributes.hasOwnProperty(key)
    record._attributes[key]
  else if record._inFlightAttributes.hasOwnProperty(key)
    record._inFlightAttributes[key]
  else
    record._data[key]

Sysys.attr = (type, options) ->
  options ||= {}
  meta =
    type: type
    isAttribute: true
    options: options
  Ember.computed( (key, value, oldValue) ->
    currentValue = null
    if arguments.length > 1
      Ember.assert "You may not set `id` as an attribute on your model. Please remove any lines that look like: `id: DS.attr('<type>')` from " + @constructor.toString(), key isnt "id"
      @send "didSetProperty",
        name: key
        oldValue: @_attributes[key] or @_inFlightAttributes[key] or @_data[key]
        value: value

      @_attributes[key] = value
      value
    else if hasValue(@, key)
      getValue @, key
    else
      getDefaultValue @, options, key
  ).property('data').meta(meta)



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
