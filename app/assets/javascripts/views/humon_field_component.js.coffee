# Binds against json
Sysys.HumonFieldComponent = Ember.Component.extend # Sysys.HumonEditorComponent.extend
  classNames: ['humon-field', 'humon-editor', 'humon-editor-inline']
  json: null
  content: null
  metatype: null

  computeMeta: ->
    meta = name: @get('metatype')
    $.extend(meta, literalOnly: true)

  initContentFromJson: ->
    initialJson = @get('json')
    # Options:
    #   - allowInvalid
    #   - controller: set the controller to this humon editor component (instance of HumonControllerMixin)
    #   - suppressNodeParentWarning: because this is the root node
    node = Humon.json2node initialJson,
             metatemplate: @computeMeta()
             allowInvalid: true
             controller: @
             suppressNodeParentWarning: yes
    node.set('nodeKey', @get('rootKey'))
    @set 'content', node

  actions:
    didCommit: (params) ->
      @sendAction 'jsonChanged', params
      @set 'json', params.rootJson

    activateNode: (node) ->
      @set 'activeHumonNode', node

  init: ->
    @_super()
    @initContentFromJson()
