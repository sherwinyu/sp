# responsible for displaying / editing a DataPoint
Sysys.DataPointView = Ember.View.extend
  classNames: ['data-point']
  classNameBindings: ['controller.active:active']
  templateName: 'data_point'
