# responsible for displaying / editing a DataPoint
Sysys.DataPointView = Ember.View.extend
  classNames: ['data-point']
  classNameBindings: ['controller.active:active']
  templateName: 'data_point'
  metaTemplate: Humon.Sleep
  details:
    awake_at: "8:43"
    awake_energy: 6
    outofbed_at: "9:50"
    outofbed_energy: 8
