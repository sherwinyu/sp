Humon.TemplateContext = Ember.Object.extend
  name: "literal"

  keys: ["asString", "asJson"]
  asString: (node) ->  node.asString()
  asJson: (node) -> node.toJson()

  iconClass: (node) -> "icon-circle-blank"
  templateName: (->
    "humon_node_#{@name}"
  ).property('name')

  # @param node  -- the Humon.Node against which to evaluate the template strings
  # @returns An object containing template strings, which node templates can bind
  # against
  materializeTemplateStrings: (node) ->
    materializedStrings = {}
    for key in @keys
      materializedStrings[key] = @[key].call(@, node)

    templateStrings = @get('templateStrings')
    # If the registered templateStrings is a function, lazy-evaluate it
    # with the node as the argument
    templateStrings = @templateStrings
    if typeof @templateStrings is "function"
      templateStrings = @templateStrings.call(@, node)
    # Iterate over template strings and evaluate them
    for own k, v of templateStrings
      materializedStrings[k] = if typeof v is "function"
                                 v.call(@, node)
                               else
                                 v

    return materializedStrings


Humon.TemplateContexts = Ember.Namespace.create
  # @param type string of the type name
  register: (type, opts) ->
    baseClass = Humon.TemplateContext
    if opts.extends instanceof Humon.TemplateContext
      baseClass = opts.extends
    Humon.TemplateContexts[type] = baseClass.extend(opts)

Humon.TemplateContexts.register "String",
  iconClass: "icon-quote-left"

Humon.TemplateContexts.register "Number",
  iconClass: "icon-superscript"

Humon.TemplateContexts.register "Null",
  iconClass: "icon-ban-circle"
  asString: -> "null"

Humon.TemplateContexts.register "Boolean",
  iconClass: "icon-check"

Humon.TemplateContexts.register "List",
  templateName: "humon_node"

Humon.TemplateContexts.register "Date",
  iconClass: "icon-calendar"
  templateName: "humon_node_date"
  templateStrings: (node)->
    date = node.val()
    month:  date.getMonth()
    day:  date.getDay()
    hour:  date.getHours()
    abbreviated:  humanized(date)
    asString:  asString(date)
    relative:  relative(date)
    verbose:  verbose(date)

Humon.TemplateContexts.Hash = Humon.TemplateContexts.List.extend()
