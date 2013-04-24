Sysys.HumonNodeView = Ember.View.extend
  templateName: 'humon_node'
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.isHash:node-hash',
    'nodeContent.isList:node-list',
    'isActive:active',
    'parentActive:activeChild',
    'suppressGap']
  classNames: ['node']

  click: (e)->
    @get('controller').activateNode @get('nodeContent'), focus: true
    e.stopPropagation()

  json_string: (->
    JSON.stringify @get('nodeContent.json')
  ).property('nodeContent.json')

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent') && @get('nodeContent')?
  ).property('controller.activeHumonNode', 'nodeContent')

  parentActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent.nodeParent')
  ).property('controller.activeHumonNode')

  # normally, there is a 5px gap at the bottom of node-collections to make room for the [ ] and { } glyphs.
  # However, if multiple collections all exit, we don't want a ton of white space, so we only show the gap
  # if this nodeCollection has an additional sibling after it
  suppressGap: (->
    @get('nodeContent.nodeParent.nodeVal.lastObject') == @get('nodeContent')
  ).property('nodeContent.nodeParent.nodeVal.lastObject')

  willDestroyElement: ->
    # @animDestroy()
    @unbindHotkeys()
    @get('nodeContent')?.set 'nodeView', null

  didInsertElement: ->
    # @animInsert()
    @initHotkeys()
    @get('nodeContent')?.set 'nodeView', @

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
            $el.css 'z-index', ''
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

  unbindHotkeys: Em.K

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>

  $labelField: ->
    @$('> span> .content-field.label-field')?.first()
  $keyField: ->
    @$('> span > .content-field.key-field')?.first()
  $idxField: ->
    @$('> span > .content-field.idx-field')?.first()
  $valField: ->
    @$('> span > .content-field.val-field')?.first()
  $proxyField: ->
    @$('> span > .content-field.proxy-field')?.first()
  $bigValField: ->
    @$('> .content-field.big-val-field')?.first()

  enterEditing: ->
    return if @get 'editing'
    console.log 'entering editing'
    x = @$bigValField()
    @set 'editing', true
    @$bigValField().addClass 'editing'
    @$('> .node-item-collection-wrapper').first().addClass 'editing'
    hmn = humon.json2humon @get 'nodeContent.json'
    @$bigValField().val hmn
    x.focus()

  exitEditing:->
    return unless @get 'editing'
    Em.assert 'must already be editing to exit', @get 'editing'
    console.log 'exiting editing'
    @set('editing', false)
    @$bigValField().removeClass 'editing'
    @$('> .node-item-collection-wrapper').first().removeClass 'editing'
    Em.View.views[ @$bigValField().attr 'id' ].removeAutogrow()
    @get('controller').smartFocus()

  commitAndContinue: ->
    if @$valField().val() == ''
      @$valField().val '{}'
    @get('controller').commitAndContinue( @$valField().val())

Sysys.DetailView = Sysys.HumonNodeView.extend
  init: ->
    Ember.run.sync() # <-- need to do this because nodeContentBinding hasn't propagated yet
    @_super()

  focusOut: (e) ->
    # TODO(syu): bug -- when the view is DELETED, this focusOut triggers!
    if @get('controller')
      @get('controller').activateNode null
