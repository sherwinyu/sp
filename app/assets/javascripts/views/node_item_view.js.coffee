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

    ###
  focusIn: (e, {suppress} = {suppress: false}) ->

    suppress = e?.eventData?.suppress
    console.log 'suppress', suppress 

    unless suppress
      console.log 'activating...'
      @get('controller').activateNode @get('content')
