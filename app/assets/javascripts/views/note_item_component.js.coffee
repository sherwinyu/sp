Sysys.NoteItemComponent = Ember.Component.extend
  tagName: "note-item"
  classNames: ["note-item"]
  rootLayout_: "layouts/hec_title" #TODO necessary?

  json: null

  myJson: null

  init: ->
    @set "myJson", $.extend( {}, @get('json'))
    @_super()

  actions:
    didCommit: (params) ->
      @set 'json', $.extend({}, @get('myJson'))

    enterPressed: (e)->
      @sendAction("enterPressed", @get('json'))
