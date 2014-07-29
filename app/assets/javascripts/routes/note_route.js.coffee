Sysys.Note = DS.Model.extend
  body: DS.attr('string')
  noteItems: Sysys.attr()

  dirtyCheck: (newNoteItemsJson) ->
    @set 'noteItems', newNoteItemsJson
    console.log @_data, @_attributes, @get('noteItems')

Sysys.NoteRoute = Ember.Route.extend
  model: (params)->
    notePromise = @get('store').find 'note', params.note_id

Sysys.NotesRoute = Ember.Route.extend
  model: (params)->
    notesPromise = @get('store').findAll 'note'

Sysys.NotesController = Ember.ArrayController.extend
  actions:
    addNote: (idx) ->
      newNote = @get('store').createRecord "note"
      newNote.set 'body', '...'
      newNote.set 'noteItems', [{body: '...'}]
      @get('content').insertAt(idx, newNote)

Sysys.NoteController = Ember.ObjectController.extend
  actions:
    jsonChanged: (newJson) ->
      @get('content').dirtyCheck newJson

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
