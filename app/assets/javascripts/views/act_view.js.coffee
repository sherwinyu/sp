Sysys.ActView = Ember.View.extend
  templateName: 'act'
  tagName: 'form'

  submit: (e)->
    @get('controller')?.commit() # Sysys.store.commit()
    false

  init: ->
    @_super()

