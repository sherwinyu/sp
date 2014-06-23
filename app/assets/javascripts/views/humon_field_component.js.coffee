# Binds against json
Sysys.HumonFieldComponent = Ember.Component.extend # Sysys.HumonEditorComponent.extend
  classNames: ['humon-field', 'humon-editor']
  json: null
  content: null

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
