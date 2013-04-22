Sysys.ActsController = Ember.ArrayController.extend
  content: null
  sortProperties: ['start_time']
  sortAscending: false
  commit: ->
    # Sysys.store.commit()

  newAct: ->
    @tx = @get('store').transaction()
    a = @tx.createRecord Sysys.Act
    a.setProperties
      start_time: Sysys.j2hn new Date()
      end_time: Sysys.j2hn new Date()
      description: Sysys.j2hn "empty description"
      detail: Sysys.j2hn(sleep: 'record your sleep' )
  commitAct: ->
    console.log 'zug'
