Sysys.NodeItemView = Ember.View.extend
  templateName: 'node_item'
  classNames: ['node-item']
  classNameBindings: [
    'isActive:active'
    ]
  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
    ret
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

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
  ).property('controller.activeHumonNode')

  init: ->
    @_super()

  focusIn: (e) ->
    @get('controller').activateNode @get('content')
    # .set('activeHumonNode', @get('content'))
    false
