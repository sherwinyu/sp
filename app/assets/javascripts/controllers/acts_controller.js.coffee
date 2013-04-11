Sysys.ActsController = Ember.ArrayController.extend
  content: null
  commit: ->
    Sysys.store.commit()

  newAct: ->
    a = Sysys.store.createRecord(Sysys.Act, description: '5')
    a.defaultValues()
