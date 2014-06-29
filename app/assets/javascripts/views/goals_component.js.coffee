#= require ./humon_editor_component

Sysys.GoalsEditorComponent = Ember.Component.extend
  tagName: "goals"
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'humon-editor-inline', 'goals-component']
  justAVar: "wargstabul"

  bindKey: (shortcut, action) ->
    controller = @get('controller')
    window.key(shortcut, ->
      controller.send action

  unbindKey: (shorcut) ->
    window.key.unbind shortcut


  json: null
  myJson: null

  setup: (->
    key 'shift+a', (args)->
      console.log "mousetrap!"
      console.log args
  ).on 'didInsertElement'

  teardown: ->
    key.unbind 'shift+a'

  init: ->
    # store a copy of the public json as myJson
    @set "myJson", @get('json').slice(0)
    @_super()


  actions:
    addGoal: ->
      @get('myJson').pushObject {goal: "new goal", completed_at: null}
      @send 'didCommit'

    didCommit: ->
      @set 'json', @myJson.slice(0)


