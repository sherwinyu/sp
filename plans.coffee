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

HNV:
  templateNameBinding: (->

  ).property('nodeContent.nodeType')
  variousHooks:
    click: ->
      HUMON.events.click( @get('nodeContent.nodeType') )

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
c
