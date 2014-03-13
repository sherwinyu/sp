Sysys.ActsController = Ember.ArrayController.extend
  actions:
    newAct: ->
      newAct = @get('store').createRecord "act"
      @get('content').insertAt(0, newAct, 0)

      # We need later + later:
      #   first loop, view acquires a controller, so that the observer is attached
      #   second loop, view is bound
      #   third loop, triggerLater fires
      Ember.run.later =>
        newAct.triggerLater 'focusNewAct'
