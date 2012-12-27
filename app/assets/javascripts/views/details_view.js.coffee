Sysys.DetailsView = Ember.View.extend
  templateName: "details"
  tagName: "div"
  hovered: false
  classNameBindings: ["hovered:highlighted"]
  classNames: ["details"]

  recurseUpParentView: ->
    pv = @get('parentView')
    console.log(pv)
    if pv
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
    console.log(ele)
    @set('hovered', false)

  enterEdit: ->
    # debugger
    console.log('this.context', @get('context'))
    console.log('this.parentView.context', @get('parentView.context'))

  exitEdit: ->

  commit: ->
    value = [1, 2, 3]






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



Sysys.KeyField = Sysys.EditableField.extend
  keysBinding: "parentViewj"
  

