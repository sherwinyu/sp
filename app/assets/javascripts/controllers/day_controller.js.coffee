Sysys.DayController = Ember.ObjectController.extend
  timeSpan: (->
    "#{@get('startedAt')} - 23:00"
  ).property('startedAt')

  init: ->
    @get('content')
    @_super()

  title: (->
    mmt = moment(@get('date'))
    mmt.format('dddd, MMM D')
  ).property 'date'

  startedAt: (->
    date = @get('content.startedAt')
    if date?.constructor == Date
      moment(@get('content.startedAt')).format "HH:mm"
  ).property('content.startedAt')

  actions:
    save: ->
      @get('content').save()

