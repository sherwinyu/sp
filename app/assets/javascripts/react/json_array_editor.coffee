#= require react/mixins/json_editor_mixin

window.sp ||= {}
rd = React.DOM

sp.JsonArrayEditor = React.createClass

  mixins: [sp.JsonEditorMixin]

  propTypes:
    # role: React.PropTypes.string
    updateHandler: React.PropTypes.func
    keyboardShortcuts: React.PropTypes.func

  _updateArrayElement: (idx, newVal) ->
    newArray = @props.value.slice 0
    newArray[idx] = newVal
    @props.updateHandler newArray

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

  render: ->
    @renderArray()
