# responsible for displaying / editing a DataPoint
Sysys.DataPointView = Ember.View.extend
  classNames: ['data-point']
  classNameBindings: ['controller.active:active']
  templateName: 'data_point'
  metaTemplate:
    name: "sleep"
  details:
    awake_at: new Date(2013, 10, 29, 8, 40)
    outofbed_at: "9:50"
    awake_energy: 6
    outofbed_energy: 8
