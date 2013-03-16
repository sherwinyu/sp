Sysys.KvpItemView = Ember.View.extend
  templateName: 'kvp_item'
  classNames: ['kvp-item']
  classNameBindings: [
    #'content.val.isActive:active'
    'isActive:active'
    ]
  isActive: (->
    # @get('content.val.isActive')
    ret = @get('controller.activeHumonNode') == @get('content.val')
    ret
  ).property('controller.activeHumonNode')
  ###
    ###

  focusIn: (e) ->
    @get('controller').set('activeHumonNode', @get('content.val'))
    false

  didInsertElement: ->
    console.log('kvp item insert')
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    console.log('kvp item destroy')
    clone = @$().clone()
    @$().replaceWith clone
    clone.slideUp 250 
