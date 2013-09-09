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
    didCommit: (params) ->
      console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
      @sendAction 'jsonChanged', params.rootJson
      @set 'json', params.rootJson

Sysys.HumonEditorView = Ember.View.extend
  templateName: 'humon-editor'
  classNames: ['humon-editor']

  content: null

  init: ->
    Em.assert @get('json')?, "json must be defined for HumonEditorView"

    @set 'content', Sysys.j2hn @get 'json'

    @set 'hooks', $.extend(
      didCommit: (params) =>
        console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
        @set 'json', params.rootJson
    , @get('hooks'))

    detailController = Sysys.DetailController.create
      hooks: @get 'hooks'
      container: Sysys.__container__
      content: @get 'content'

    @set 'controller', detailController
    @_super()

window.appendHev = (selector, initialJson) ->
  @hev = Sysys.HumonEditorView.create
    hooks:
      didUp: ->
        console.log 'didUp'
    json: initialJson
  @hev.appendTo(selector)
  @hev
