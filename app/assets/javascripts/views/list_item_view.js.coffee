Sysys.ListItemView = Ember.View.extend
  templateName: 'list_item'
  classNames: ['list-item']

  didInsertElement: ->
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250

  isActive: (->
    # @get('content.val.isActive')
    ret = @get('controller.activeHumonNode') == @get('content')
    ret
  ).property('controller.activeHumonNode')
  ###
    ###

  focusIn: (e) ->
    # @get('controller').activateNode @get('content') 
    false
