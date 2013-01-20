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

  childrenDetailsViews: ->
    @$('> div > span > div.details').map (i, ele) ->
      Sysys.vfi(ele.id)

  recurseUpParentView: ->
    pv = @get('parentView.parentView')
    if pv and pv instanceof Sysys.DetailsView
      pv.set('hovered', false)
      pv.recurseUpParentView()

  mouseEnter: (e)->
    @set('hovered', true)
    @recurseUpParentView()
    e.preventDefault()
    false

  mouseLeave: (e)->
    ele = e.toElement
    id = $(ele).closest('.details').attr('id')
    if id
      view = Ember.get("Ember.View.views.#{id}")
      view.set('hovered', true)
    @set('hovered', false)

  keyUp: (e) ->
    if e.keyCode == 13
      @commit()
    false

  edit: ->
    if @get 'isEditing'
      @commit()
    else
      @enterEdit()

  enterEdit: ->
    val = Sysys.JSONWrapper.recursiveSerialize @get 'details'
    json = JSON.stringify val
    @set 'commitValue', json
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
    try
      # TODO(syu): write a SYSON parser and validator
      rawValue = @get('commitValue')
      value = parse rawValue
      value = Sysys.JSONWrapper.recursiveDeserialize value
      # json = JSON.parse @get('commitValue')
      # value = Sysys.JSONWrapper.recursiveDeserialize json
      @set('details', value)
      upperDetailsView = @get('parentView.parentView')
      upperDetailsView = undefined unless upperDetailsView instanceof Sysys.DetailsView
      index = @get('index')
      Ember.assert("index and upperDetailsView need to coexist", index? == upperDetailsView?)
      if index? and upperDetailsView?
        upperDetails = upperDetailsView.get('details')
        if upperDetails.isHash?
          upperDetails.set( upperDetails.keyForIndex(index), value)
        else
          upperDetails.set("#{index}", value)
      @exitEdit()
      @rerender()
      upperDetailsView?.rerender()
    catch error
      console.log "invalid JSON!", error

  keysBinding: "parentView.details._keys"

  keyName: (key, value) ->
    details = @get('details')
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
