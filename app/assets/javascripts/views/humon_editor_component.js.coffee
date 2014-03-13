Sysys.HumonEditorComponent = Ember.Component.extend Humon.HumonControllerMixin,
  rootLayout_: "layouts/hec_title"
  classNames: ['humon-editor', 'humon-editor-inline']
  hooks: null
  json: null
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

  ###
  initialJsonDidChange
  This is to allow this component to bind against deferred value.

  When a HEC is created, the passed-in value for `initialJson` can either be existent
  or undefined.
  If `initialJson` is initialy undefined:
    - we assume that it is a deferred value (actually, an undefined value
      that will become defined when a promise is resolved in the future)
    - we set content and rerender when this observer fires
  If `initialJson` is initially defined:
    - we assume that it's a static (or already resolved) value
    - set content; and the norma view life cycle will render it for us.
  ###
  initClassNames: (->)

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

  _jsonUpdated: (->
    x = @get('json')
    console.log(x)
  ).observes('json')

  init: ->
    @_super()
    @initContentFromJson()

  # TODO(syu): is this safe? if this object never gets cloned?
  hooks:
    didCommit: (params) ->
      # console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
      @sendAction 'jsonChanged', params.rootJson
      @set 'json', params.rootJson

    didUp: (e) ->
      @sendAction 'upPressed', e

    didDown: (e)->
      @sendAction 'downPressed', e
