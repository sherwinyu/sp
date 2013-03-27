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
    $el = @$()
    if @get('isActive') and anims?.insert
      switch anims['insert'] 
        when 'slideDown'
          $el.animate bottom: $el.css('height'), 0
          $el.animate bottom: 0, 185
        when 'slideUp'
          $el.css 'z-index', 555
          $el.animate top: $el.css('height'), 0
          $el.animate top: 0, 185, ->
            $el.css 'z-index', 0
        when 'fadeIn'
          $el.hide 0
          $el.fadeIn 185
        when 'appear'
          Em.K
      anims.insert = undefined
      return
    $el.hide 0
    $el.slideDown 375

  animDestroy: ->
    anims = @get('controller.anims')
    $el = @$().clone()
    @.$().replaceWith $el
    if @get('isActive') and anims?.destroy
      switch anims.destroy
        when 'slideDown'
          $el.slideDown 185
        when 'slideUp'
          # $el.animate bottom: $el.css('height'), 185
          $el.slideUp 185
        when 'fadeOut'
          $el.fadeOut 185
        when 'disappear'
          $el.addClass 'tracker'
          $el.hide 0
      anims.destroy = undefined
      delay 185, -> $el.remove()
      return
    console.log 'sliding up'
    $el.slideUp 250, ->
      $el.remove()

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
