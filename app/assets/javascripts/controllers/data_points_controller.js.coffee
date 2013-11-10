Sysys.DataPointsController = Ember.ArrayController.extend
  init: ->
    @get('content')
    @_super()
  actions:
    newDataPoint: ->
      newDp = @get('store').createRecord "data_point"
      @get('content').insertAt(0, newDp, 0)
