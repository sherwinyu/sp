Sysys.NodeItemView = Ember.View.extend
  templateName: 'node_item'
  classNames: ['node-item']

  didInsertElement: ->
    @$().slideUp 0
    @$().slideDown 250
  willDestroyElement: ->
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
  ).property('controller.activeHumonNode')

  focusIn: (e) ->
    @get('controller').set('activeHumonNode', @get('content'))
    false
