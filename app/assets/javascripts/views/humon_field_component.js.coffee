# Binds against json
Sysys.HumonFieldComponent = Ember.Component.extend # Sysys.HumonEditorComponent.extend
  tagName: "humon-field"
  classNames: ['humon-field', 'humon-editor', 'humon-editor-inline']
  classNameBindings: ['readOnly', 'inline']
  json: null
  content: null
  metatype: null
  inline: null
  readOnly: null


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

    # @ref HumonControllerMixin#actions#didCommit
    didCommit: (params) ->
      @sendAction 'jsonChanged', params
      @set 'json', params.rootJson

    activateNode: (node) ->
      @set 'activeHumonNode', node

    upPressed: (e)->
      @sendAction 'upPressed', e

    downPressed: (e)->
      @sendAction 'downPressed', e

    enterPressed: (e, node, uiPayload)->
      @sendAction 'enterPressed', e, node.toJson()

    deletePressed: (e, node)->
      @sendAction 'deletePressed', e, node.toJson()


  init: ->
    @_super()
    @initContentFromJson()

Sysys.DisplayFieldComponent = Sysys.HumonFieldComponent.extend
  tagName: 'display-field'
