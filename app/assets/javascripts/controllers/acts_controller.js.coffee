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
      ####
      #### TODO(syu): Fix this -- need to morph these properties into humon nodes, but also set the rawValue properly (right now it's ''json'')
      a.setProperties
        start_time: new Date()
        description: Sysys.j2hn "empty description"
        detail: Sysys.j2hn(sleep: 'record your sleep' )
  commitAct: ->
    console.log 'zug'
