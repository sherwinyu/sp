Sysys.ListItemView = Ember.View.extend
  templateName: 'list_item'
  classNames: ['list-item']

  didInsertElement: ->
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    console.log('list item destroy')
    clone = @$().clone()
    @.$().replaceWith clone
    clone.slideUp 250 #, "easeInOutQuad"
