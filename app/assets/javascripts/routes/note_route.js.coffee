Sysys.Note = DS.Model.extend
  body: DS.attr('string')
  noteItems: DS.attr()

Sysys.NoteRoute = Ember.Route.extend
  model: (params)->
    notePromise = @get('store').find 'note', params.note_id

  setupController: (controller, model) ->
    @_super()

Sysys.NotesRoute = Ember.Route.extend
  model: (params)->
    notesPromise = @get('store').findAll 'note'

Sysys.NotesController = Ember.ArrayController.extend
  actions:
    addNote: (idx) ->
      newNote = @get('store').createRecord "note"
      newNote.set 'body', '...'
      newNote.set 'noteItems', []
      @get('content').insertAt(idx, newNote)

Sysys.NoteController = Ember.ObjectController.extend
  actions:
    addNoteItem: (noteItem) ->
      idx = @get('noteItems').indexOf noteItem
      @get('noteItems').insertAt (idx + 1), {body: ""}
    jsonChanged: () ->
      debugger

Sysys.NoteView = Ember.View.extend
  classNames: ['note']
  classNameBindings: ['controller.isDirty:dirty:clean']

Sysys.NotesView = Ember.View.extend
  classNames: ['notes']

  setupHotkeys: (->
    @bindKey 'shift+a', (e) =>
      return if key.isTyping(e)
      @get('controller').send 'addNote', 0
      return false
    @bindKey 'up', (e) =>
      @get('controller').send 'upPressed', e
    @bindKey 'down', (e) =>
      @get('controller').send 'downPressed', e
  ).on 'didInsertElement'

  teardownHotkeys: ( ->
    @unbindKey 'shift+a'
    @unbindKey 'up'
    @unbindKey 'down'
  ).on 'willDestroyElement'
