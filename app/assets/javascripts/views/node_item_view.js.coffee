Sysys.NodeItemView = Ember.View.extend
  templateName: 'node_item'
  classNames: ['node-item']
  classNameBindings: [
    'isActive:active'
    ]
  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
  ).property('controller.activeHumonNode')

  willInsertElement: ->
    console.log 'rurp'

  didInsertElement: ->
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250

