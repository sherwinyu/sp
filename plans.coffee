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
