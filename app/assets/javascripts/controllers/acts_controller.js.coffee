Sysys.ActsController = Ember.ArrayController.extend
  content: null
  commit: ->
    Sysys.store.commit()

  newAct: ->
    a = Sysys.Act.createRecord description: 'empty'
