#= require_self
#= require ./node
#= require ./humon_values
#= require ./humon_utils
#= require ./template_contexts
#= require ./humon_controller_mixin

window.Humon = Ember.Namespace.create
# _types: ["Number", "Boolean", "Null", "Date", "String", "List", "Hash"]
  _types: ["Number", "Boolean", "Null", "Time", "Date", "String", "List", "Hash"]

  contextualize: (type) ->
    if type.constructor == Humon.Node
      type = type.get('nodeType')

    # `type` is a string
    key = type[0].toUpperCase() + type.slice(1)
    Humon[key] || Em.assert("Could not find type Humon.#{key}")

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
