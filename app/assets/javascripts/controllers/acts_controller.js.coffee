Sysys.ActsController = Ember.ArrayController.extend
  content: null
  commit: ->
    # Sysys.store.commit()

  newAct: ->
    debugger
    a = Sysys.Act.createRecord description: 'empty'
    a.set 'detail', Sysys.j2hn({})
    a.set 'description', 'ZOOOOOOOOOOOOOOOOOOOOOOOOOOTS'
    store = @get 'store'
    a.save()

    
