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
  humon_node_currency.hbs

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
    switch node.get('nodeType')
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
        Humon.types[type].hn2j(nodeVal)

      when 'date'
        ret = node.get('nodeVal').toString()
      when 'literal'
        ret = nodeVal
      else
