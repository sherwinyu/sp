Sysys.ActController = Ember.ObjectController.extend
  actions:
    save: ->
      @get('content').save()
