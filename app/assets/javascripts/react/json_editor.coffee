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
    # idx: React.PropTypes.number
    # value: React.
    # v2: React.PropTypes.func

  updateHandler: (idx, e) ->
    newValue = computeNewValue
    @props.updateHandler

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
        jsyaml.load e.target.value
      catch error
        e.target.value
    @props.updateHandler newVal

  renderLiteral: ->
    rd.input
      value: @props.value
      onChange: @_updateLiteral

  renderArray: ->
    rd.ol null,
      for val, idx in @props.value
        rd.li null,
          sp.JsonEditor
            key: idx
            value: val
            updateHandler: @_updateArrayElement.bind null, idx

  renderObject: ->
    rd.ul null,
      for key, idx in Object.keys @props.value
        val = @props.value[key]
        rd.li null,
          "key:"
          sp.JsonEditor
            key: "key#{idx}"
            value: key
            updateHandler: @_updateObjectKey.bind null, idx, key
          sp.JsonEditor
            key: "val#{idx}"
            value: val
            updateHandler: @_updateObjectValue.bind null, idx, key

  render: ->
    if @props.value? and typeof @props.value == 'object' and @props.value not instanceof Array
      x = @renderObject()
    else if @props.value? and typeof @props.value == 'object' and @props.value instanceof Array
      x = @renderArray()
    else
      x = @renderLiteral()
    return rd.span className: 'group',
      x
