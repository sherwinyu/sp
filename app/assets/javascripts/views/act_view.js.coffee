Sysys.ActView = Ember.View.extend
  templateName: 'act'
  classNames: ['well']
  classNameBindings: ['context.isDirty:dirty']

  submit: (e)->
    @get('controller')?.commitAct() # Sysys.store.commit()
    false

  init: ->
    @_super()
  click: ->
    console.log 'click!'
    @get('controller').transitionToRoute('acts.activeAct', @get('content'))
