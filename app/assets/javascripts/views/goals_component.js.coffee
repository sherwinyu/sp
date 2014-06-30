Sysys.GoalsEditorComponent = Ember.Component.extend
  tagName: "goals"
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'humon-editor-inline', 'goals']
  json: null
  myJson: null

  setup: (->
    @bindKey 'shift+a', (e) =>
      return if key.isTyping(e)
      @send 'addGoal'
      return false

    @bindKey 'up', (e) =>
      @sendAction 'upPressed', e

    @bindKey 'down', (e) =>
      @sendAction 'downPressed', e
  ).on 'didInsertElement'

  teardown: ->
    @unbindKey 'shift+a'
    @unbindKey 'up'
    @unbindKey 'down'

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

    toggleCompletedAt: (e, goalText) ->
      goals = @get('myJson')
      goal = goals.find( (goal) -> goal.goal == goalText)
      if goal.completed_at
        Ember.set goal, 'completed_at', null
      else
        Ember.set goal, 'completed_at', new Date()
      @send 'didCommit'
