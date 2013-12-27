# responsible for displaying / editing a DataPoint
Sysys.DayView = Ember.View.extend
  classNames: ['day']
  templateName: 'day'
  modelChanged: (->
    console.log 'content-id:', @get('controller.content.id')
    Ember.run.scheduleOnce "afterRender", @, ->
      console.log @get('state'), @
      # @rerender()
  ).observes('controller.content')
