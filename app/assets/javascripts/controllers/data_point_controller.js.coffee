Sysys.DataPointController = Ember.ObjectController.extend

  dataPointDidChange: (->
    @set 'initialJson', @get('content.details')
  ).observes 'content'

  init: ->
    @get('content')
    @_super()

  actions:
    submitDataPoint: ->
      @get('content').set('submittedAt', new Date())
      @get('content').save()

