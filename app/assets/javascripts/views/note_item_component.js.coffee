Sysys.NoteItemComponent = Ember.Component.extend
  tagName: "note-item"
  classNames: ["note-item"]
  rootLayout_: "layouts/hec_title" #TODO necessary?

  json: null
  myJson: null

  init: ->
    @_super()

  actions:
    didCommit: (params) ->
      @sendAction 'jsonChanged'

    enterPressed: (e)->
      @sendAction("enterPressed", @get('json'))

Sysys.NoteItemsComponent = Ember.Component.extend
  tagName: "note-items"
  classNames: ["note-items"]

  init: ->
    @_super()
    @set('json', @get('json').slice 0)

  actions:
    addNoteItem: (noteItem) ->
      idx = @get('json').indexOf noteItem
      @get('json').insertAt (idx + 1), {body: ""}

    jsonChanged: ->
      @sendAction 'jsonChanged', @get('json')
