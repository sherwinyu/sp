Sysys.DataPointsController = Ember.ArrayController.extend
  init: ->
    @get('content')
    @_super()
  actions:
    save: (dataPoint) ->
      dataPoint.save()
