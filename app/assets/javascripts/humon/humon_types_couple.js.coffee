#
# Couple type-registration
#


  # _inferFromJson -- attempts to convert a json value to this type
  #   param json json: the candidate json object
  #   return: if successful, a value of this type
  #           if unsuccessful, a falsy value
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # type registration order (calls to HumonType.register)
  #
  # TODO(syu): update and generalize to work for all humon types and include it in
  # the standard suite. AKA make it work for booleans: return a hash {matchesType, value}
  # problem is that right now yu can't distinguish between a literal false and a false as in failure
  # _inferFromJson: (json) ->


HumonTypes.register "couple",
  name: "couple"
  templateName: "humon_node_couple"
  iconClass: "icon-calendar"

  # matchesAgainstJson -- checks a json value to see if it could be this type
  #   param json json: the candidate json
  #   returns: a boolean, true if it could be this value, false if not
  # This just takes @_inferFromJson and coerces the return value to a boolean.
  # Context: called by HumonTypes.resolveType while iterating over all registered types
  matchesAgainstJson: (json) ->
    true
    !!_inferFromJson(json)

  # templateStrings -- values made available to the humon_node template via
  # view.templateStrings.<name>
  # Here, we're using the function (lazy evaluation) version
  # We can also declare a straight up object.
  templateStrings: (node) ->
    first: node.get('nodeVal').self[0]
    # month:  node.get('nodeVal').getMonth()
    # verbose:  verbose(node.get('nodeVal'))

  defaultNodeVal: ->
    [null, null]

  # hnv2j -- humon node val to json. Converts from nodeVal of this type to json
  # Context: called by HumonUtils.humonNode2json, which is in turn called by the Store
  # in preparation for serializing this to
  hnv2j: (nodeVal) ->
    [Sysys.hn2j(nodeVal.self[0]), Sysys.hn2j(nodeVal.self[1]) ]

  # j2hnv -- json to humon nodeVal. Converts from json value to a nodeVal of this type
  # Context: called by HumonUtils.j2hn when setting the nodeVal for literal nodes
  # Note: this is different from HumonUtils.j2hn, which outputs **humon node objects**.
  # j2hnv outputs humon node `nodeVal`s
  j2hnv: (json, context=null) ->
    # val = _inferFromJson(json)
    val = Sysys.HumonNodeCouple.create()
    val.self[0] = Sysys.j2hn(json[0], context.node)
    val.self[1] = Sysys.j2hn(json[1], context.node)
    val
