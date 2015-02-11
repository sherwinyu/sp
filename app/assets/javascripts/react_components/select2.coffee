React = require 'react'
require 'select2'
require 'select2/select2.css'

rd = React.DOM

Select2 = React.createClass {
  displayName: 'Select2'

  propTypes: {
    allowClear: React.PropTypes.bool.isRequired
    createSearchChoice: React.PropTypes.func
    formatSelection: React.PropTypes.func
    options: React.PropTypes.array.isRequired
    placeholder: React.PropTypes.string.isRequired
    multiple: React.PropTypes.bool
    value: React.PropTypes.any
    defaultValue: React.PropTypes.any
    onChange: React.PropTypes.func
    width: React.PropTypes.string.isRequired
  }

  getDefaultProps: -> {
    allowClear: false
    width: '100%'
    placeholder: ''
  }

  # Using a function for data apparently lets select2 pull in the latest @props.options each time.
  dataFunc: -> {results: @props.options}

  componentDidMount: ->
    $(@getDOMNode()).select2 {
      allowClear: @props.allowClear
      createSearchChoice: @props.createSearchChoice
      formatSelection: @props.formatSelection
      width: @props.width
      placeholder: @props.placeholder
      data: @dataFunc
      multiple: @props.multiple
    }
    # When the component first mounts, it's possible that the caller has specified defaultValue
    # (indicating it's an uncontrolled component) or value (controlled component).
    # See http://facebook.github.io/react/docs/forms.html
    if @props.value == undefined
      $(@getDOMNode()).select2 'val', @props.defaultValue
    else
      @syncValue()
      $(@getDOMNode()).on 'select2-selecting.select2', @handleChange
      $(@getDOMNode()).on 'select2-loaded.select2', @syncValue
      # NOTE We should really be listening to select2-removing, as e.preventDefault below doesn't work with
      # removed, but v3.5.2 isn't properly firing the removing event.
      $(@getDOMNode()).on 'select2-removed.select2 removed.select2', @handleRemove
    return

  handleRemove: (e) ->
    # Always prevent default to stop change, rely on props update instead.
    e.preventDefault()
    @handleValueSet null
    return

  handleChange: (e) ->
    # Always prevent default to stop change, rely on props update instead.
    e.preventDefault()
    @handleValueSet e.val
    return

  handleValueSet: (val) ->
    @props.onChange?(val)
    if not @props.multiple
      $(@getDOMNode()).select2 'close'
    return

  getValue: -> $(@getDOMNode()).select2 'val'

  syncValue: ->
    $(@getDOMNode()).select2 'val', @props.value
    return

  shouldComponentUpdate: (nextProps, nextState) ->
    if nextProps.value != @props.value
      return true
    if not _.isEqual nextProps.data, @props.data
      return true
    return false

  componentDidUpdate: ->
    if @props.value != undefined
      @syncValue()
    return

  componentWillUnmount: ->
    $(@getDOMNode)
      .off '.select2'
      .select2 'destroy'
    return

  render: ->
    return rd.input {type: 'hidden'}
}

module.exports = Select2
