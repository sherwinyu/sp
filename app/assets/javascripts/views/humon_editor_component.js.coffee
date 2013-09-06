Sysys.HumonEditorComponent = Ember.Component.extend Sysys.HumonControllerMixin,
  classNames: ['humon-editor']
  content: null
  hooks: null

  init: ->
    @set 'content', Sysys.j2hn @get 'json'
    detailController = Sysys.DetailController.create()
    @_super()

  # TODO(syu): is this safe? if this object never gets cloned?
  hooks:
    didCommit: (json) ->
      @sendAction 'jsonChanged', json
      @set 'json'

Sysys.HumonEditorView = Ember.View.extend
  templateName: 'humon-editor'
  classNames: ['humon-editor']

  content: null

  init: ->
    Em.assert @get('json')?, "json must be defined for HumonEditorView"

    unless @get 'json'
      @set 'json', test: 'json'

    @set 'content', Sysys.j2hn @get 'json'

    @set 'hooks', $.extend(
      didCommit: (json) =>
        @set 'json', json
    , @get('hooks'))

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
