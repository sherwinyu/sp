Sysys.NoteItemComponent = Ember.Component.extend
  tagName: "note-item"
  classNames: ["note-item"]
  rootLayout_: "layouts/hec_title" #TODO necessary?

  json: null

  myJson: null

  init: ->
    @set "myJson", @get('json')
    @_super()

  actions:
    arg: (e)->
