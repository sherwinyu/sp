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

  templateContextFor: (type) ->
    if type.constructor == Humon.Node
      type = type.get('nodeType')
    key = type
    key = type[0].toUpperCase() + type.slice(1)
    ctx = Humon.TemplateContexts[key] || Humon.TemplateContext
    ctx.create()
