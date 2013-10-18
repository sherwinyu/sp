Sysys.RtdpActivitiesController = Ember.ArrayController.extend
  sortProperties: ['duration']
  itemController:  'rtdpActivity'
  sortAscending: false

Sysys.RtdpActivityController = Ember.ObjectController.extend
  durationString: (->
    dur = @get('content.duration') # in seconds
    utils.sToDurationString(dur)
  ).property('content.duration')

  fillStyle: (->
    x = @get('content.productivity') * 50
    r = Math.round((100 - x) / 200 * 230)
    g = Math.round(230 - r)
    b = Math.round(128 - Math.abs(x))
    colorStyle = "rgb(#{r}, #{g}, #{b})"
    "color: #{colorStyle}"
  ).property 'content.productivity'

  init: ->
    @_super()
    @get('durationString')

