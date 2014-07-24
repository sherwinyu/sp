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
