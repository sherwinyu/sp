Sysys.ActsController = Ember.ArrayController.extend
  actions:
    newAct: ->
      newAct = @get('store').createRecord "act"
      @get('content').insertAt(0, newAct, 0)
