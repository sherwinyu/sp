# TODO #DEFER create a components directory
Sysys.HumonFieldComponent = Ember.Component.extend
  tagName: "humon-field"
  classNames: ['humon-field', 'humon-editor', 'humon-editor-inline']
  classNameBindings: ['readOnly', 'inline']

  # Externally bound json
  json: null

  # The Humon.Node representation
  content: null

  # [String] that will be used as the 'name' property in computeMeta.
  metatype: null

  inline: null
  readOnly: null

  # Sets Creates a metatemplate only specifying name (from `metatype`) and setting
  # `literalOnly` to true
  # @return [metatemplate]
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

  init: ->
    @_super()
    @initContentFromJson()

  actions:
    # @param params:
    #   - controller: the instance of the controller
    #   - node: the committed node
    #   - rootJson: json representation of the root node
    #   - key: a string if the key was committed; null otherwise
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

    # Call the bound enterPressed handler, giving it the json representation
    # @param node [Humon.Node] node whose UI originated the enterPressed
    # @param uiPayload [json] the key and val field text, received from NodeView#enterPressed
    enterPressed: (e, node, uiPayload)->
      @sendAction 'enterPressed', e, node.toJson()

    # Call the bound deletePressed handler, giving it the json representation
    # @param node [Humon.Node] node whose UI originated the deletePressed
    deletePressed: (e, node)->
      @sendAction 'deletePressed', e, node.toJson()
