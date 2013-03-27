Sysys.HumonNodeView = Ember.View.extend
  contentBinding: null
  templateName: 'humon_node'
  classNameBindings: [
    'content.isLiteral:node-literal:node-collection',
    'isActive:active']
  classNames: ['node']

  json_string: (->
    JSON.stringify @get('content.json')
  ).property('content.json')

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('content')
  ).property('controller.activeHumonNode')

  willDestroyElement: ->
    @animDestroy()
    @unbindHotkeys()

  didInsertElement: ->
    @animInsert()
    @initHotkeys()
    @get('content')?.set 'nodeView', @

  animInsert: ->
    anims = @get('controller.anims')
    if @get('isActive') and anims?.insert
      if anims['insert'] == 'slideDown'
        @$().hide 0
        @$().slideDown 250
        anims.destroy = undefined
        return
      if anims['insert'] == 'slideUp'
        @$().slideDown 0
        @$().slideUp 250
        anims.destroy = undefined
        return
      if anims['insert'] == 'fadeIn'
        @$().hide 0
        @$().fadeIn 250
        anims.destroy = undefined
        return
    @$().hide 0
    @$().slideDown 250

  animDestroy: ->
    clone = @$().clone()
    @.$().replaceWith clone
    anims = @get('controller.anims')
    if @get('isActive') and anims?.destroy
      if anims['destroy'] == 'slideDown'
        clone.slideDown 250
        return
        anims.destroy = undefined
      if anims['destroy'] == 'slideUp'
        clone.slideUp 250
        anims.destroy = undefined
        return
      if anims['destroy'] == 'fadeOut'
        clone.fadeOut 250
        anims.destroy = undefined
        return
    clone.slideUp 250

  didDestroyElement: ->
    @get('content')?.set 'nodeView', null

  unbindHotkeys: Em.K

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>

  $keyField: ->
    @$('> span > .content-field.key-field')?.first()
  $idxField: ->
    @$('> span > .content-field.idx-field')?.first()
  $valField: ->
    @$('> span > .content-field.val-field')?.first()
  $proxyField: ->
    @$('> span > .content-field.proxy-field')?.first()
