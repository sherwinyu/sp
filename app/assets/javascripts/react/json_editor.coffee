#= require utils/react
#= require js-yaml
#= require react/json_literal_editor
#= require react/json_array_editor
#= require react/mixins/json_editor_mixin

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
  mixins: [sp.JsonEditorMixin]

  keyboardShortcuts: (e) ->
    console.log e.which

  _updateObjectKey: (updateAtIdx, oldKey, newKey) ->
    newObject = utils.react.renameObjectKey @props.value, oldKey, newKey
    @props.updateHandler newObject

  _updateObjectValue: (updateAtIdx, key, newVal) ->
    newObject = $.extend {}, @props.value
    newObject[key] = newVal
    @props.updateHandler newObject


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
      x = sp.JsonArrayEditor
        value: @props.value
        # keyboardShortcuts: @props.keyboardShortcuts
        updateHandler: @props.updateHandler
    else
      x = sp.JsonLiteralEditor
        role: @props.role
        value: @props.value
        keyboardShortcuts: @props.keyboardShortcuts
        updateHandler: @props.updateHandler
    return rd.span className: 'group',
      x
