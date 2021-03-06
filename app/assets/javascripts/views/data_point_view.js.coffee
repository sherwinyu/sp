# responsible for displaying / editing a DataPoint
Sysys.DataPointView = Ember.View.extend
  classNames: ['data-point']
  classNameBindings: ['controller.active:active', 'context.isDirty:dirty:clean']
  templateName: 'data_point'

  metaTemplate:
    name: "sleep"
    defaultDate: new Date(2013,4,5)

  details:
    awake_at: new Date(2013, 10, 29, 8, 40)
    up_at: "9:50"
    awake_energy: 6
    up_energy: 8
  init: ->
    @_super()
