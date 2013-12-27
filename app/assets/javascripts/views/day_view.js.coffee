# responsible for displaying / editing a DataPoint
Sysys.DayView = Ember.View.extend
  classNames: ['day']
  templateName: 'day'
  _id: null
  modelChanged: (->
    Ember.run.once  @, ->
      console.warn "DayView modelChanged despite not being inDOM" unless @get('state') is 'inDOM'
      @rerender() if @get('state') is 'inDOM'
  ).observes('controller.id')

  updateId: (-> @set '_id', @$().attr('id')).on 'didInsertElement'
