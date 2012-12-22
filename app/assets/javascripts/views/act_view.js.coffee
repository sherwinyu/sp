Sysys.ActView = Ember.View.extend
  templateName: 'act'
  tagName: 'form'
  classNameBindings: ['context.isDirty:dirty']

  submit: (e)->
    @get('controller')?.commit(@get('context')) # Sysys.store.commit()
    false

  init: ->
    @_super()

  zorger: Sysys.EnumerableObjectViaObject.create(_magic: {a :1, b: 2, c:3})



