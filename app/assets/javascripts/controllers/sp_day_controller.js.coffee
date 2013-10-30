Sysys.SpDayController = Ember.ObjectController.extend
  init: ->
    @get('content')
    @_super()

  title: (->
    mmt = moment(@get('date'))
    mmt.format('dddd, MMM D')
  ).property 'date'

  startedAt: (->
    moment(@get('content.startedAt')).format "H:M"
  ).property('content.startedAt')

