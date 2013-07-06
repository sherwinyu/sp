#### TYPE SYSTEM NOTES

# exists a system to register new data types
Humon.register 'currency',
  templateName: 'currency'
  validate: (string) ->
    makeSureIsANumber(string)
  parseFromRaw: (raw) ->
    raw.toNumber()
  fromJson: ->
  toJson: ->
  forDisplay: ->
  objectProperties:
    waga: 5


Humon.register 'date',

HNV:
  templateNameBinding: (->

  ).property('nodeContent.nodeType')
  variousHooks:
    click: ->
      HUMON.events.click( @get('nodeContent.nodeType') )


      ###
The '``register`` arguments fall into two categories

  1. Those that concern the server side implementation (mongo)
  2. Those that only concern client side display (-- think as if we were releasing HumonNode Flow UI as a library)

Furthermore, there are two points at which we can inject custom types


  1. HumonUtils.j2hn / hn2j -- initially intended for
  2. Within the actual Humon parser!!!
  We're going to go with __2__


   *
      * Humon parser works ONLY in the realm of text.
      * TEXT to json, essentially
   * where does it make sense to build additional type functionality>
   ###
###
  humon_node_date.hbs
  <span class="blocky">
    {{#if view.nodeContent.nodeParent.isList}}
      {{view "Sysys.IdxField" valueBinding="view.nodeContent.nodeIdx" rawValueBinding="view.nodeContent.nodeIdx"}}
    {{else}}
      {{view "Sysys.KeyField" rawValueBinding="view.nodeContent.nodeKey"}}<span class="colon-glyph">:</span>
    {{/if}}

    {{#if view.nodeContent.isLiteral}}
      {{view "Sysys.ValField" rawValueBinding="view.nodeContent.json" }}
    {{else}}
      <span class="open-glyph"> </span> {{!view "Sysys.ProxyField" }}
    {{/if}}
  </span>
###
#
#           HN2J
#
  humonNode2json: (node)->
    nodeVal = node.get('nodeVal')
    ret = undefined
    type = node.get('nodeType')
    switch type
      when 'list'
        ret = []
        for child in nodeVal
          ret.pushObject Sysys.HumonUtils.humonNode2json child
      when 'hash'
        ret = {}
        for child in nodeVal
          key = child.get('nodeKey')
          key ?= nodeVal.indexOf child
          ret[key] = Sysys.HumonUtils.humonNode2json child
      else
        assert node.isLiteral
        Humon.types[type].hn2j(nodeVal) # nodeVal is the underlying value

#
#           HN2J
#
  # given a json object (typically, the output from Humon.parse)
  json2humonNode: (json, nodeParent=null)->
    node = Sysys.HumonNode.create
      nodeParent: nodeParent

    if Sysys.HumonUtils.isHash json
      node.set('nodeType', 'hash')
      children = Em.A()
      for own key, val of json
        child = Sysys.HumonUtils.json2humonNode val, node
        child.set 'nodeKey', key
        children.pushObject child
      node.set 'nodeVal', children
    else if Sysys.HumonUtils.isList json
      node.set 'nodeType', 'list'
      children = Em.A()
      for val in json
        child = Sysys.HumonUtils.json2humonNode val, node
        children.pushObject child
      node.set 'nodeVal', children
    else ## is a literal
      Em.assert isLiteral(json)
      # determine what sort of type it is
      type = Humn.resolveType(json)
      node.set('nodeType', type)
      node.set 'nodeVal', Humon.types[type].j2hn(nodeVal)

Humon.resolveType = (json)->
  # assert json is not list, is not hash
  for type in Humon.types.keys
    if Humon.types[type].matchAgainstJson json
      return "type"
  if Humon.types.isNumeric(json)
    return "number"
  if Humon.types.isBoolean(json)
    return "boolean"
  if Humon.types.isNull(json)
    return "null"
  if Humon.types.isString(json)
    return "string"
  Em.assert "unrecognized type for json2humonNode: #{json}", false
