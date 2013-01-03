Sysys.ActsController = Ember.ArrayController.extend
  commit: ->
    Sysys.store.commit()

  init:->
    @set 'content', Sysys.store.findAll(Sysys.Act)

  newAct: ->
    a = Sysys.store.createRecord(Sysys.Act, {description: "new description"})
