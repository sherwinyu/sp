# Binds against json
Sysys.HumonFieldComponent = Ember.Component.extend # Sysys.HumonEditorComponent.extend
  classNames: ['humon-field', 'humon-editor']
  json: null
  content: null

  computeMeta: ->
    excludedTypes: ["List", "Hash"]


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
      # console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
      @sendAction 'jsonChanged', params.rootJson
      @set 'json', params.rootJson

    activateNode: (node) ->
      @set 'activeHumonNode', node

  init: ->
    @_super()
    @initContentFromJson()
