Sysys.ActsController = Ember.ArrayController.extend
  content: null
  sortProperties: ['start_time']
  sortAscending: false
  commit: ->
    # Sysys.store.commit()

  newAct: ->
    @tx = @get('store').transaction()
    a = @tx.createRecord Sysys.Act
    a.then (a)->
      a.setProperties
        start_time: new Date()
        description: "empty description"
        detail: Sysys.j2hn(sleep: 'record your sleep' )
  commitAct: ->
    console.log 'zug'
