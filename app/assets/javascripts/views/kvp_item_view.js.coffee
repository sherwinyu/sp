Sysys.KvpItemView = Ember.View.extend
  templateName: 'kvp_item'
  classNames: ['kvp-item']
  didInsertElement: ->
    console.log('kvp item insert')
    @$().slideUp 0
    @$().slideDown 250

  willDestroyElement: ->
    console.log('kvp item destroy')
    clone = @$().clone()
    @$().replaceWith clone
    clone.slideUp 250 
