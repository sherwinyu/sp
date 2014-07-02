#= require_self
#= require_tree ./views
#= require ./node
#= require ./humon_values
#= require ./humon_utils
#= require ./template_contexts
#= require ./humon_controller_mixin

window.Humon = Ember.Namespace.create
# _types: ["Number", "Boolean", "Null", "Date", "String", "List", "Hash"]
  _types: ["Number", "Boolean", "Null", "Time", "Date", "String", "List", "Hash", "Text"]
  _literals: ["Number", "Boolean", "Null", "Time", "Date", "String", "Text"]
  _collections: ["List", "Hash"]

  ##
  # @param [String | Humon.Node] type
  # @return [subclass of Humon.Value] the class corresponding to the provided type
  contextualize: (typeName) ->
    if typeName.constructor == Humon.Node
      typeName = typeName.get('nodeType')

    className = Em.String.classify(typeName)
    Humon[className] || Em.assert("Could not find type Humon.#{className}")

  ##
  # @param [Humon.Node] node the Humon.Node whose type will be used to look up the template
  #   context
  # @return [Humon.TemplateContext]
  templateContextFor: (node) ->
    typeName = node.get('nodeType')
    # `typeName` is an underscored string. e.g., "day_summary"
    key = Em.String.classify(typeName)

    # Attempt to look up the key on TemplateContexts.
    # If that fails, default to either the Hash template or the Literal template
    # depending on whether node is a collection.
    ctx = Humon.TemplateContexts[key] or
            if node.get('isCollection')
              Humon.TemplateContexts.Hash
            else
              Humon.TemplateContext

    # Instantiate the template context
    ctx.create()

Humon.nodeAttr = (attrKey) ->
  ftn = ( (key, value, oldValue) ->
      # console.log key, value, oldValue
      # Setter
      if arguments.length > 1
        @_setChildByKey(key, value)
      # Getter
      else
        @_getChildByKey(attrKey)
    ).property('_value.@each.nodeVal')
  return ftn


##
# A variation of a computed property that basically operates on the underlying json representation
# of the node child specified by `attrAccessorKey`
#
# @param attrAccessorKey [String] the name of the child (key into childMetatemplates)
Humon.valAttr = (attrAccessorKey)->
  nodeAccessorKey = '_' + attrAccessorKey

  # Setter:
  #   if `value` is undefined, call @deleteChild and return undefined
  #   if child already exists (aka @get(key) is a HumonNode)
  #     use node.tryToCommit
  #     return the json representation
  #   otherwise (child node doesn't exist yet)
  #     create a new node with the appropriate parent and meta (from childMetatemplates)
  #     call set on the key, with the new node as the value
  #       NOTE this in turn calls the nodeAttr computed property
  ftn = ( (key, value, oldValue) ->
          # console.log key, value, oldValue
          node = @get(nodeAccessorKey)

          # Handle case when node doesn't yet exist?
          # Factor node templates into this.
          # We can leverage existing validation / type checking via tryToCommit
          # Setter
          if arguments.length > 1
            if value == undefined
              @deleteChild(node)
              return undefined
            if node?
              node.tryToCommit val: value
              return node.val()
            else
              # TODO(syu): ADD NODE PARENT
              node = HumonUtils.json2node value, metatemplate: @constructor.childMetatemplates[attrAccessorKey], nodeParent: @node
              node.set 'nodeKey', attrAccessorKey
              @set(nodeAccessorKey, node)
              return node.val()

          # Getter
          else
            node = @get(nodeAccessorKey)
            if node?
              Em.assert "node #{node} is a Humon.node", node instanceof Humon.Node
            node?.val()
        ).property(nodeAccessorKey, nodeAccessorKey + '._value')
  return ftn
