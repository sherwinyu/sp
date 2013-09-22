Sysys.DataPointController = Ember.ObjectController.extend
  init: ->
    @get('content')
    @_super()

  actions:
    save: ->
      @get('content').set('submittedAt', new Date())
      @get('content').save()
    submitDataPoint: ->
      @get('content').set('submittedAt', new Date())
      @get('content').save()
    activateDataPointView: ->
      @set('active', true)
    deactivateDataPointView: ->
      @set('active', false)

