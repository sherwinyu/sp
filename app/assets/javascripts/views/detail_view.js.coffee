###
Sysys.DetailView = Sysys.HumonNodeView.extend
  init: ->
    Ember.run.sync() # <-- need to do this because nodeContentBinding hasn't propagated yet
    @_super()

  didInsertElement: ->
    Ember.run.sync()
    @_super()

  focusOut: (e) ->
    if @get('controller')
      @get('controller').send('activateNode', null)
###
