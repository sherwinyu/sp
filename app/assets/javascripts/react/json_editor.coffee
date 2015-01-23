#= require utils/react
#= require js-yaml
#= require react/json_literal_editor
#= require react/json_array_editor
#= require react/mixins/json_editor_mixin

JsonEditorMixin = require 'react/mixins/json_editor_mixin'
React = require 'react'
bs = require 'utils/bs'
rd = React.DOM

JsonEditorRoot = React.createClass

  getInitialState: ->
    value: @props.initialValue

  updateValue: (value) ->
    @setState value: value

  render: ->
    JsonEditor
      onKeyDown: ->
        debugger
      value: @state.value
      updateHandler: @updateValue

JsonEditor = React.createClass

  propTypes:
    updateHandler: React.PropTypes.func
    keyboardShortcuts: React.PropTypes.func
    role: React.PropTypes.string

  mixins: [JsonEditorMixin]

  render: ->
    if @type() is 'object'
      x = JsonObjectEditor
        value: @props.value
        updateHandler: @props.updateHandler

    else if @type() is 'array'
      x = JsonArrayEditor
        value: @props.value
        updateHandler: @props.updateHandler

    else
      x = JsonLiteralEditor
        role: @props.role
        value: @props.value
        keyboardShortcuts: @props.keyboardShortcuts
        updateHandler: @props.updateHandler

module.exports = JsonEditorRoot
