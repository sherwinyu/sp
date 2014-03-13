Sysys.DataPointsController = Ember.ArrayController.extend
  actions:
    newDataPoint: ->
      newDp = @get('store').createRecord "data_point"
      @get('content').insertAt(0, newDp, 0)
