Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: [
    'content.isLiteral:node-literal:node-collection',
    'isActive:active']
  classNames: ['node']

  json_string: (->
    JSON.stringify @get('content.json')
  ).property('content.json')

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
  ).property('controller.activeHumonNode')

  willDestroyElement: ->
    @get('content')?.set 'nodeView', null
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250

  didInsertElement: ->
    @initHotkeys()
    @get('content')?.set 'nodeView', @
    @$().slideUp 0
    @$().slideDown 250

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>
