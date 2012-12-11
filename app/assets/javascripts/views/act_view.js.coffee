Sysys.ActView = Ember.View.extend
  templateName: 'act'
  click: (e)->
    Sysys.store.commit()
