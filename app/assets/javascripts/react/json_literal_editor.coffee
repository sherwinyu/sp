window.sp ||= {}
rd = React.DOM

sp.JsonLiteralEditor = React.createClass
  propTypes:
    role: React.PropTypes.string
    updateHandler: React.PropTypes.func
    keyboardShortcuts: React.PropTypes.func
    role: React.PropTypes.string

  _updateLiteral: (e) ->
    newVal =
      try
        # jsyaml.load e.target.value
        JSON.parse e.target.value
      catch error
        e.target.value
    @props.updateHandler newVal

  render: ->
    rd.input
      className: "json-field #{@props.role}"
      value: @props.value
      onChange: @_updateLiteral
      onKeyDown: @props.keyboardShortcuts
