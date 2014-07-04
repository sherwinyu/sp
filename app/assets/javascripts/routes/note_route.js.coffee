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
