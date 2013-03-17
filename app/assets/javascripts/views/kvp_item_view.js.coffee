Sysys.KvpItemView = Ember.View.extend
  templateName: 'kvp_item'
  classNames: ['kvp-item']
  classNameBindings: [
    #'content.val.isActive:active'
    'isActive:active'
    ]
  isActive: (->
    # @get('content.val.isActive')
    ret = @get('controller.activeHumonNode') == @get('content')
    ret
  ).property('controller.activeHumonNode')
  ###
    ###

  focusIn: (e) ->
    @get('controller').set('activeHumonNode', @get('content'))
    false

  didInsertElement: ->
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    clone = @$().clone()
    @$().replaceWith clone
    clone.slideUp 250 
