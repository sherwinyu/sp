Sysys.DayController = Ember.ObjectController.extend
  timeSpan: (->
    "#{@get('startedAt')} - #{@get('endedAt')}"
  ).property('startedAt', 'endedAt')

  title: (->
    mmt = moment(@get('date'))
    mmt.format('dddd, MMM D')
  ).property 'date'

  startedAt: (->
    date = @get('content.startedAt')
    if date?.constructor == Date
      moment(@get('content.startedAt')).format "HH:mm"
    else
      ""
  ).property('content.startedAt')

  endedAt: (->
    date = @get('content.endedAt')
    if date?.constructor == Date
      moment(@get('content.endedAt')).format "HH:mm"
    else
      ""
  ).property('content.endedAt')

  actions:
    save: ->
      utils.track "day saved", day: @get('content.id')
      @get('content').save()

