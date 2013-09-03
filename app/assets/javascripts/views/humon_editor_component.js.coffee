Sysys.HumonEditorComponent = Ember.Component.extend Sysys.HumonControllerMixin,
  classNames: ['humon-editor']
  end_time: Sysys.j2hn "wala wala"
  init: ->
    @set 'content', Sysys.j2hn @get 'json'
    detailController = Sysys.DetailController.create()
    @_super()

  committed: ->
    @sendAction 'jsonChanged', Sysys.hn2j @get('content')

Sysys.HumonEditorView = Ember.View.extend
  templateName: 'humon-editor'
  init: ->
    unless @get 'json'
      @set 'json', test: 'json'
    @set 'content', Sysys.j2hn @get 'json'
    detailController = Sysys.DetailController.create
      hooks: @get 'hooks'
      container: Sysys.__container__
      content: @get 'content'

    @set 'controller', detailController
    @_super()

window.hev = Sysys.HumonEditorView.create
  hooks:
    didUp: ->
      console.log 'didUp'
      debugger
