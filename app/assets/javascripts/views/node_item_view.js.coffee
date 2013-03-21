Sysys.NodeItemView = Ember.View.extend
  templateName: 'node_item'
  classNames: ['node-item']

  willInsertElement: ->
    console.log 'rurp'

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

  init: ->
    @_super()

  focusIn: (e) ->
    @get('controller').set('activeHumonNode', @get('content'))
    false
