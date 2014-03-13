Sysys.ActView = Ember.View.extend
  templateName: 'act'
  classNames: ['well']
  classNameBindings: ['context.isDirty:dirty']
  focusNewAct: ->
    console.log "focusing", @$()
    @$('.val-field').first().focus()

  init: ->
    @_super()
    Ember.run.later =>
      @get('controller.content').one('focusNewAct', @, @focusNewAct)
