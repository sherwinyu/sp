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
    # Currently called only by deleteGoal and addGoal. Just focuses on the last
    # item by default.
    refocus: ->
      Ember.View.smartFocus(@$('.line-item-selectable').last())

    # Called by humon-field(bound to humon-field#jsonChanged)
    # Simply do a `set` on the our `json` field, giving it a clone of our json
    # We must clone it otherwise comparison by reference says it's the same array
    didCommit: ->
      @set 'json', @myJson.slice(0)

    # TODO think about how to make this "index-sensitive"
    # It's not hard here, but how do do it with just json objects?
    addGoal: ->
      @get('myJson').pushObject {goal: "new goal", completed_at: null}
      @send 'didCommit'
      Ember.run.later => @send 'refocus'


    # Removes the first goal that has the given goalText
    deleteGoal: (e, goalText) ->
      goals = @get('myJson')
      goal = goals.find( (goal) -> goal.goal == goalText)
      goals.removeObject goal
      @send 'didCommit'
      Ember.run => @send 'refocus'

    # Toggles the completedAt attribute of a goal
    # This finds the first goal with the given goal text and then toggles it
    toggleCompletedAt: (e, goalText) ->
      goals = @get('myJson')
      goal = goals.find( (goal) -> goal.goal == goalText)
      if goal.completed_at
        Ember.set goal, 'completed_at', null
      else
        Ember.set goal, 'completed_at', new Date()
      @send 'didCommit'
