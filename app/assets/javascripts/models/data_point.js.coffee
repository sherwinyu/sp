Sysys.DataPoint = DS.Model.extend
  submittedAt: Sysys.attr('date')
  startedAt: Sysys.attr('date')
  endedAt: Sysys.attr('date')
  details: Sysys.attr()
