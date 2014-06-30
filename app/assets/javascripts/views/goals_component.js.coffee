#= require ./humon_editor_component

Sysys.GoalsEditorComponent = Ember.Component.extend
  tagName: "goals"
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'humon-editor-inline', 'goals-component']
  justAVar: "wargstabul"

  bindKey: (shortcut, action) ->
    controller = @get('controller')
    window.key(shortcut, (e, obj) =>
      unless $(e.target).parents("#" + @get('elementId')).length
        return
      action.call(@, e, obj)
    )
    # controller.send action

  unbindKey: (shorcut) ->
    window.key.unbind shortcut

  json: null
  myJson: null

  setup: (->
    @bindKey 'shift+a', (e) =>
      return if key.isTyping(e)
      @send 'addGoal'
      return false

    @bindKey 'up', =>
      console.log 'goals-editor-up', arguments
      @sendAction 'upPressed', arguments[0]

    @bindKey 'down', =>
      console.log 'goals-editor-up', arguments
      @sendAction 'downPressed', arguments[0]
  ).on 'didInsertElement'

  teardown: ->
    @unbindKey 'shift+a'

  init: ->
    # store a copy of the public json as myJson
    @set "myJson", @get('json').slice(0)
    @_super()


  actions:
    refocus: ->
      Ember.View.smartFocus(@$('.line-item-selectable').last())

    # TODO think about how to make this "index-sensitive"
    # It's not hard here, but how do do it with just json objects?
    addGoal: ->
      @get('myJson').pushObject {goal: "new goal", completed_at: null}
      @send 'didCommit'
      Ember.run.later => @send 'refocus'

    didCommit: ->
      @set 'json', @myJson.slice(0)

    deleteGoal: (e, goalText) ->
      goals = @get('myJson')
      goal = goals.find( (goal) -> goal.goal == goalText)
      goals.removeObject goal
      @send 'didCommit'
      Ember.run =>
        @send 'refocus'
