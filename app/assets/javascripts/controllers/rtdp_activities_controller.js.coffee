Sysys.RtdpActivitiesController = Ember.ArrayController.extend
  sortProperties: ['duration']
  itemController:  'rtdpActivity'
  sortAscending: false

Sysys.RtdpActivityController = Ember.ObjectController.extend
  durationString: (->
    dur = @get('content.duration') # in seconds
    utils.sToDurationString(dur)
  ).property('content.duration')
  init: ->
    @_super()
    @get('durationString')

