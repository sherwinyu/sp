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
  variousHooks:
    click: ->
      HUMON.events.click( @get('nodeContent.nodeType') )

