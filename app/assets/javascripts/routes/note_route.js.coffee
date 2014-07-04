Sysys.Note = DS.Model.extend
  body: DS.attr('string')

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
      @get('content').insertAt(idx, newNote)

Sysys.NotesView = Ember.View.extend
  setupHotkeys: (->
    @bindKey 'shift+a', (e) =>
      return if key.isTyping(e)
      @get('controller').send 'addNote', 0
      return false
  ).on 'didInsertElement'

  teardownHotkeys: ( ->
    @unbindKey 'shift+a'
  ).on 'willDestroyElement'
