Sysys.SpDay = DS.Model.extend
  date: Sysys.attr('day')
  note: Sysys.attr('string')
  sleep: Sysys.attr()
  yesterday: DS.belongsTo('sp_day')
  tomorrow: DS.belongsTo('sp_day')
