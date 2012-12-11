Sysys.ActionView = Ember.View.extend
  templateName: 'action'
  click: (e)->
    Sysys.store.commit()
