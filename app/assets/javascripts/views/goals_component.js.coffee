#= require ./humon_editor_component

Sysys.GoalsEditorComponent = Sysys.HumonEditorComponent.extend
  tagName: "goals"
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'goals-component']
  justAVar: "wargstabul"

  json: null
  myJson: null


  init: ->
    myJson = @get('json').slice(0)
    @set("myJson", myJson)
    @_super()

  actions:

    addGoal: ->
      @get('myJson').pushObject {goal: "new goal", completed_at: null}

    didCommit: (params)->
      # @sendAction 'jsonChanged', params.rootJson
      @set 'json', @myJson.slice(0)



