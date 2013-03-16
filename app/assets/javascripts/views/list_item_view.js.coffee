Sysys.ListItemView = Ember.View.extend
  templateName: 'list_item'
  classNames: ['list-item']

  didInsertElement: ->
    console.log('list item insert')
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    console.log('list item destroy')
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
    @get('controller').set('activeHumonNode', @get('content'))
    false
