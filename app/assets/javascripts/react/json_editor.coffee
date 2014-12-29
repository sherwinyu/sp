window.sp ||= {}
rd = React.DOM

sp.JsonEditorRoot = React.createClass

  getInitialState: ->
    value: @props.initialValue ? [5,5,5]

  updateValue: (value) ->
    @setState value: value

  render: ->
    sp.JsonEditor
      value: @state.value
      updateHandler: @updateValue

sp.JsonEditor = React.createClass

  propTypes:
    updateHandler: React.PropTypes.func
    # idx: React.PropTypes.number
    # value: React.
    # v2: React.PropTypes.func

  updateHandler: (idx, e) ->
    newValue = computeNewValue
    @props.updateHandler

  _updateObject: (idx, newVal) -> null

  _updateArrayElement: (idx, newVal) ->
    newArray = @props.value.slice 0
    newArray[idx] = newVal
    @props.updateHandler 42 # newArray


  _updateLiteral: (e) ->
    newVal = e.target.value
    @props.updateHandler newVal

  renderLiteral: ->
    console.log 'literal render: value=', @props.value
    rd.input
      value: @props.value
      onChange: @_updateLiteral

  renderArray: ->
    for val, idx in @props.value
      console.log val, idx
      sp.JsonEditor
        key: idx
        value: val
        updateHandler: @_updateArrayElement.bind null, idx

  renderObject: ->
    for key, val of @props.value
      sp.JsonEditor
        value: key
        updateHandler: @renameKey.bind null, key

      sp.JsonEditor
        value: val
        updateHandler: @updateHandler.bind null, idx


  render: ->
    if typeof @props.value == 'object' and not @props.value instanceof Array
      x = @renderObject()
    else if typeof @props.value == 'object' and @props.value instanceof Array
      x = @renderArray()
    else
      x = @renderLiteral()
    return rd.div className: 'group',
      rd.h1 null, 'hi'
      x
