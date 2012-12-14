Sysys.ActView = Ember.View.extend
  templateName: 'act'
  tagName: 'form'

  submit: (e)->
    Sysys.store.commit()

  init: ->
    @_super()

