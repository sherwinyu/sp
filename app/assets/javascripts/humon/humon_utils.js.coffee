window.HumonUtils =
  ## A metatemplate
  ###
  #{
  name: "date"
  childMetatemplates
    awake_at:
      name: "time"       <-- note the name should always be in under_score_snake_case


  }
  ###

  ##
  # @param [metatemplate] metatemplate
  # @return [instance of Humon.HumonValue]
  # If metatemplate.typeName is specified, then look it up.
  _typeClassFromMeta: (metatemplate) ->
    # If metatemplate has an explicitly defined type class, just use that
    # Actually, no don't just use it. Throw an error for now.
    if metatemplate.type?
      throw new Error("Metatemplate should not contain `type` field")
      return metatemplate.type

    # If the metatemplate is already typified under Humon.#{metatemplate.name}"
    # then just return the type classs
    typeClassName = Ember.String.classify(metatemplate.name)
    if Humon.HumonValue.detect(Humon[typeClassName]?.create())
      # TODO(syu): assert that the TypeClass's metatemplate is equivalent to the passed in
      # `metatemplate`
      return Humon[typeClassName]

    Em.assert("Metatemplate must have a name", metatemplate.name?)
    @_typifyClassFromMeta(metatemplate)

  ##
  # Turns the metatemplate into a a new type, with a name
  _typifyClassFromMeta: (metatemplate) ->
    throw new Error "not implemented yet"

  ##
  # @param [JSON] json json representation to test
  # @return [Humon.HumonValue subclass] a class representing a subclass of `HumonValue`
  # Called by json2node when no context is available
  _resolveTypeClassFromJson: (json) ->
    for type in Humon._types
      typeClass = Humon.contextualize(type)
      if typeClass.matchesJson(json)
        return typeClass
    throw new Error "Unresolved type for payload #{JSON.stringify json}!"

  ##
  # @param [JSON] json the json payload to convert to HumonValue wrapped in a Humon.Node
  # @param context -- optional
  #   - nodeParent: the node that will be the parent context of the current json payload
  #   - metatemplate
  #     - name: a subclass of Humon.HumonValue, indicating the type that `json` should resolve to
  #   - allowInvalid [boolean] if true, allows this node to be invalid
  #
  # @return [Humon.Node] the returned node wraps a Humon.Value
  # The returned HumonNode will have its nodeParent set to `context.nodeParent`
  # If `metatemplate` is provided, @_typeClassFromMeta determines the type class.
  # If `metatemplate` is not provided, @_resolveTypeClassFromJson determines the type class.
  #
  # @return [Humon.Node]
  #   The returned node has nodeMeta, nodeVal, nodeType, and nodeParent set correctly.
  #   TODO(syu): what about setting nodeKey?
  json2node: (json, context={}) ->

    if context.suppressNodeParentWarning?
      delete context.suppressNodeParentWarning
    else
      console.warn "No nodeParent found: j2n(#{JSON.stringify json}), context: #{JSON.stringify context} " unless context.nodeParent?
    if context.nodeParent?
      Em.assert "Node parent #{context.nodeParent} must be a Humon.Node", context.nodeParent instanceof Humon.Node

    if context.suppressControllerWarning? and !context.controller?
      delete context.suppressControllerWarning
      context.controller = "CONTROLLER WARNING SUPPRESSED"

    node = Humon.Node.create
      nodeParent: context.nodeParent
      controller: context.controller || context?.nodeParent?.controller || Em.assert("Controller should be present")

    typeClass =
      if context.type?
        throw new Error("json2node Context should not contain `type` field")
        context.type
      else if context.metatemplate
        HumonUtils._typeClassFromMeta(context.metatemplate)
      else # Don't pass in context because this occurs when context isn't provided!
        HumonUtils._resolveTypeClassFromJson json

    # Create a new context, with the node set to the to-be-returned Humon.Node,
    # and merge in the current context.
    nodeValContext = $.extend {node: node}, context

    nodeVal = typeClass.tryJ2hnv json, nodeValContext
    node.set 'nodeMeta', context.metatemplate
    node.set 'nodeVal', nodeVal
    node.set 'nodeType', nodeVal.name()

    return node

  node2json: (node)->
    node.get('nodeVal').toJson()

Humon.n2j = HumonUtils.node2json
Humon.j2n = HumonUtils.json2node
Humon.json2node = HumonUtils.json2node
