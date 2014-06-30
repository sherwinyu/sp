Sysys.HumonEditorComponent = Ember.Component.extend Humon.HumonControllerMixin,
  tagName: "humon-editor"
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'humon-editor-inline']
  hooks: null
  json: null
  metatemplate: null

  ###
  # Available public API component actions
    * jsonChanged
    * focusLost
    * focusGained
    * upPressed
    * downPressed
  ###

  handleFocusOut: (e)->
    @sendAction 'focusLost'
  handleFocusIn: (e)->
    @sendAction 'focusGained'

  initContentFromJson: ->
    initialJson = @get('json')
    # Options:
    #   - allowInvalid
    #   - controller: set the controller to this humon editor component (instance of HumonControllerMixin)
    #   - suppressNodeParentWarning: because this is the root node
    node = Humon.json2node initialJson,
             metatemplate: @get('metaTemplate')
             allowInvalid: true
             controller: @
             suppressNodeParentWarning: yes
    node.set('nodeKey', @get('rootKey'))
    @set 'content', node

  init: ->
    @_super()
    @initContentFromJson()


  actions:
    # params:
    #   - controller: the instance of the controller
    #   - node: the committed node
    #   - rootJson: json representation of the root node
    #   - key: a string if the key was committed; null otherwise
    didCommit: (params) ->
      @sendAction 'jsonChanged', params.rootJson
      @set 'json', params.rootJson

    upPressed: (e)->
      @sendAction 'upPressed', e

    downPressed: (e)->
      @sendAction 'downPressed', e

    enterPressed: (e, node, uiPayload) ->
      node.get('nodeVal').enterPressed(e, uiPayload)
