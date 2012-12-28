Sysys.DetailsView = Ember.View.extend
  templateName: "details"
  tagName: "div"
  hovered: false
  classNameBindings: ["hovered:highlighted"]
  classNames: ["details"]
  isEditing: false
  commitValue: ""

  identification: (->
    @toString().slice(19, 27)
  ).property()



  ###
  commitValue: ((key, val) ->
    JSON.parse(@get('context').
  ).property()
  ###

  recurseUpParentView: ->
    pv = @get('parentView')
    if pv
      pv.set('hovered', false)
      pv.recurseUpParentView()

  mouseEnter: (e)-> 
    @set('hovered', true)
    @recurseUpParentView()
    e.preventDefault()
    false

  keyUp: (e) ->
    if e.keyCode == 13
      @commit()
      
    
  mouseLeave: (e)->

    ele = e.toElement
    id = $(ele).closest('.details').attr('id')
    if id
      view = Ember.get("Ember.View.views.#{id}")
      view.set('hovered', true)
    @set('hovered', false)

  enterEdit: ->
    console.log('this.context', @get('context'))
    console.log('this.parentView.context', @get('parentView.context'))
    if @get('isEditing')
      @commit()
    else
      @set('isEditing', true)

  exitEdit: ->
    @set('isEditing', false)

  collapse: ->
    cur = @$('.collapsible').css('display')
    unless cur == "block"
      @$('.collapsible').css('display', 'block')
    else
      @$('.collapsible').css('display', 'none')

  commit: ->
    console.log 'comitting, commit val = '
    console.log @get('commitValue')
    try 
      value = JSON.parse(@get('commitValue'))
      @set('context', value)
      @exitEdit()
      @rerender()
    catch error
      console.log "invalid JSON!", error








  keysBinding: "parentView.context._keys"

  keyName: (key, value) ->
    details = @get('context')
    idx = @get('contentIndex')
    if arguments.length == 1 # getter
      #details.getKeyByVal(
      @get('keys').get("#{idx}")
    else # setter
      @get('keys').set("#{idx}", value)

  keyNameForEnumObjects: ((key, value) ->
    idx = @get('contentIndex')
    if arguments.length == 1 # getter
      @get('keys').get("#{idx}")
    else # setter
      @get('keys').set("#{idx}", value)
  ).property('keysBinding', 'contentIndex')

  init: ->
    @_super()
    @set('commitValue', JSON.stringify(@get('context')))
