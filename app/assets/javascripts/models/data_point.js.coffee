Sysys.DataPoint = DS.Model.extend
  submittedAt: DS.attr('date')
  startedAt: DS.attr('date')
  endedAt: DS.attr('date')
  details: Sysys.attr()
