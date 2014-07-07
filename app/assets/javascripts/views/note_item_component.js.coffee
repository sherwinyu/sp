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
    didCommit: (params) ->
      json = params.rootJson
      if JSON.stringify(params.rootJson) == JSON.stringify(@origJson)
        json = @origJson
      @sendAction 'jsonChanged', json
      @set 'json', json

    enterPressed: (e)->
      @sendAction("enterPressed", @get('json'))
