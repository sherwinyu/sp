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
    # We shouldn't be using the 'type' field right now
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
    else
      # Otherwise, create a NEW typeclass dynamically based on the metatemplate.
      Em.assert("Metatemplate must have a name (not implemeneted yet)", metatemplate.name?)
      @_typifyClassFromMeta(metatemplate)

  ##
  # Turns the metatemplate into a a new type, with a name
  _typifyClassFromMeta: (metatemplate) ->
    throw new Error "not implemented yet"

  ##
  # @param [JSON] json json representation to test
  # @param [JSON] metatemplate, only uses metatemplate.literalOnly
  # @return [Humon.HumonValue subclass] a class representing a subclass of `HumonValue`
  # Called by json2node when no context is available
  _resolveTypeClassFromJson: (json, metatemplate={}) ->
    types = if metatemplate.literalOnly then Humon._literals else Humon._types
    for type in types
      typeClass = Humon.contextualize(type)
      if typeClass.matchesJson(json)
        return typeClass

    # Uses Humon.String as the catchall, if we're in literal-only mode.
    # Otherwise, it's an error!
    return Humon.String if metatemplate.literalOnly
    throw new Error "Unresolved type for payload #{JSON.stringify json}!"

  ##
  # Creates a standalone (deep clone) metatemplate objet from the context.
  # Also automatically sets up inherited meta settings from nodeParent
  #   - readOnly: if parent is readOnly, by default this child will be as well
  # @param context [JSON]
  #   - nodeMeta
  #   - nodeParent
  _createMetatemplate: (context) ->
    baseMeta =
      readOnly: context.nodeParent?.nodeMeta?.readOnly
      defaultDate: context.nodeParent?.nodeMeta?.defaultDate
    # Deep clone merge the context.metatemplate (if specified),
    # overriding any settings from baseMeta
    return $.extend(true, baseMeta, context.metatemplate)


  ##
  # @param [JSON] json the json payload to convert to HumonValue wrapped in a Humon.Node
  # @param context -- optional
  #   - nodeParent: the node that will be the parent context of the current json payload
  #   - metatemplate
  #     - name: a subclass of Humon.HumonValue, indicating the type that `json` should resolve to
  #     - defaultDate
  #     - readOnly
  #   - allowInvalid [boolean] if true, allows this node to be invalid
  #   - suppressNodeParentWarning
  #   - suppressControllerWarning: whether to warn when
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

    # The node to be returned
    # - controller
    #   by default, inherits nodeParent's controller (unless context.controller is directly
    #   specified, as is in the case of HumonEditorComponent#
    # - nodeParent: context.nodeParent
    #   which should only be null when this is the rootNode
    node = Humon.Node.create
      nodeParent: context.nodeParent
      controller: context.controller || context?.nodeParent?.controller || Em.assert("Controller should be present")

    typeClass =
      if context.type?
        throw new Error("json2node Context should not contain `type` field")
        context.type
      # TODO this is a temporary fix: have to handle the case when we don't want to fully specify
      # the `name`, but still want to set metatemplate properties (e.g., readOnly: true)
      else if context.metatemplate?.name
        HumonUtils._typeClassFromMeta(context.metatemplate)
      else # Don't pass in context because this occurs when context isn't provided!
        HumonUtils._resolveTypeClassFromJson json, context.metatemplate

    # hacky
    if context.metatemplate?.literalOnly && typeClass == Humon.String
      json = "#{json}"

    # Create a new context, with the node set to the to-be-returned Humon.Node,
    # and merge in the current context.
    nodeValContext = $.extend {node: node}, context
    node.set 'nodeMeta', @_createMetatemplate(context)

    nodeVal = typeClass.tryJ2hnv json, nodeValContext
    node.set 'nodeVal', nodeVal
    node.set 'nodeType', nodeVal.name()

    return node

  node2json: (node)->
    node.get('nodeVal').toJson()

Humon.n2j = -> HumonUtils.node2json.apply HumonUtils, arguments
Humon.j2n = -> HumonUtils.json2node.apply HumonUtils, arguments
Humon.json2node = -> HumonUtils.json2node.apply HumonUtils, arguments
