#= require utils/react
#= require js-yaml
#= require react/json_literal_editor
#= require react/json_array_editor
#= require react/mixins/json_editor_mixin

window.sp ||= {}
rd = React.DOM

sp.JsonEditorRoot = React.createClass

  getInitialState: ->
    value: @props.initialValue

  updateValue: (value) ->
    @setState value: value

  render: ->
    sp.JsonEditor
      onKeyDown: ->
        debugger
      value: @state.value
      updateHandler: @updateValue

sp.JsonEditor = React.createClass

  propTypes:
    updateHandler: React.PropTypes.func
    keyboardShortcuts: React.PropTypes.func
    role: React.PropTypes.string

  mixins: [sp.JsonEditorMixin]

  render: ->
    if @type() is 'object'
      x = sp.JsonObjectEditor
        value: @props.value
        updateHandler: @props.updateHandler

    else if @type() is 'array'
      x = sp.JsonArrayEditor
        value: @props.value
        updateHandler: @props.updateHandler

    else
      x = sp.JsonLiteralEditor
        role: @props.role
        value: @props.value
        keyboardShortcuts: @props.keyboardShortcuts
        updateHandler: @props.updateHandler
