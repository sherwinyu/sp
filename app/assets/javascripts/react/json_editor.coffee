#= require utils/react
#= require js-yaml
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
    keyboardShortcuts: React.PropTypes.func
    role: React.PropTypes.string

    # idx: React.PropTypes.number
    # value: React.
    # v2: React.PropTypes.func

  keyboardShortcuts: (e) ->
    console.log e.which

  _updateObjectKey: (updateAtIdx, oldKey, newKey) ->
    newObject = utils.react.renameObjectKey @props.value, oldKey, newKey
    @props.updateHandler newObject

  _updateObjectValue: (updateAtIdx, key, newVal) ->
    newObject = $.extend {}, @props.value
    newObject[key] = newVal
    @props.updateHandler newObject

  _updateArrayElement: (idx, newVal) ->
    newArray = @props.value.slice 0
    newArray[idx] = newVal
    @props.updateHandler newArray

  _updateLiteral: (e) ->
    newVal =
      try
        # jsyaml.load e.target.value
        JSON.parse e.target.value
      catch error
        e.target.value
    @props.updateHandler newVal

  renderLiteral: ->
    rd.input
      className: "json-field #{@props.role}"
      value: @props.value
      onChange: @_updateLiteral
      onKeyDown: @props.keyboardShortcuts

  renderArray: ->
    rd.ol null,
      for val, idx in @props.value
        rd.li null,
          sp.JsonEditor
            role: 'value-field'
            key: idx
            value: val
            updateHandler: @_updateArrayElement.bind null, idx
            keyboardShortcuts: @_objectValueShortcuts

  _objectValueShortcuts: (e, idx) ->
    elements = $('.json-field.value-field')
    idx = elements.index $(e.target)

    if e.key == 'ArrowUp'
      idx = (idx + elements.length - 1) % elements.length

    if e.key == 'ArrowDown'
      idx = (idx + elements.length + 1) % elements.length
    console.log el

    el = elements[idx]
    el.focus()



  renderObject: ->
    rd.ul null,
      for key, idx in Object.keys @props.value
        val = @props.value[key]
        rd.li null,
          "key:"
          sp.JsonEditor
            role: 'key-field'
            key: "key#{idx}"
            value: key
            updateHandler: @_updateObjectKey.bind null, idx, key
          sp.JsonEditor
            role: 'value-field'
            key: "val#{idx}"
            value: val
            updateHandler: @_updateObjectValue.bind null, idx, key
            keyboardShortcuts: @_objectValueShortcuts

  render: ->
    if @props.value? and typeof @props.value == 'object' and @props.value not instanceof Array
      x = @renderObject()
    else if @props.value? and typeof @props.value == 'object' and @props.value instanceof Array
      x = @renderArray()
    else
      x = @renderLiteral()
    return rd.span className: 'group',
      x
