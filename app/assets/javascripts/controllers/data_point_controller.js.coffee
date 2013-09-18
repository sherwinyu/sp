Sysys.DataPointController = Ember.ObjectController.extend

  init: ->
    @get('content')
    @_super()

  actions:
    submitDataPoint: ->
      @get('content').set('submittedAt', new Date())
      @get('content').save()

