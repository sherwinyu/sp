#= require_self
#= require ./node
#= require ./humon_values
#= require ./humon_utils
#= require ./template_contexts
#= require ./humon_controller_mixin

window.Humon = Ember.Namespace.create
# _types: ["Number", "Boolean", "Null", "Date", "String", "List", "Hash"]
  _types: ["Number", "Boolean", "Null", "Time", "Date", "Text", "String", "List", "Hash"]

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
