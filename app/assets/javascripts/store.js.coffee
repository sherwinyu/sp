#= require store/sysys_attr.js.coffee
#= require store/day_transform.js.coffee
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
