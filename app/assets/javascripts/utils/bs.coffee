React = require 'react'

joinClasses = (className) ->
  className ?= ''
  argLength = arguments.length
  if argLength > 1
    for ii in [1...argLength] by 1
      nextClass = arguments[ii]
      if nextClass
        className = (if className then className + ' ' else '') + nextClass
  return className

rd = React.DOM
cx = React#addons.classSet

Row = React.createClass
  displayName: 'Row'

  render: ->
    return rd.div {className: joinClasses('row', @props.className)}, @props.children

Col = React.createClass
  displayName: 'Col'

  render: ->
    classes = [@props.className]
    for size in ['xs', 'sm', 'md', 'lg']
      if @props[size]
        classes.push "col-#{size}-#{@props[size]}"
    return rd.div {className: joinClasses(classes...)}, @props.children

FormInput = React.createClass
  displayName: 'FormInput'

  render: ->
    return @transferPropsTo(
      rd.input className: 'form-control'
    )

TextArea = React.createClass
  displayName: 'TextArea'

  render: ->
    return @transferPropsTo(
      rd.textarea className: 'form-control'
    )

Label = React.createClass
  displayName: 'Label'

  render: ->
    label = rd.label className: 'control-label',
      @props.children

    return @transferPropsTo label

FieldError = React.createClass
  displayName: 'FieldError'
  propTypes:
    message: React.PropTypes.arrayOf(React.PropTypes.string)

  # If an error is actually present, display the (first) message. Otherwise, show an empty span.
  render: ->
    return rd.span className: 'field-error',
      @props.message?[0]

FormGroup = React.createClass
  displayName: 'FormGroup'
  propTypes:
    hasError: React.PropTypes.bool

  render: ->
    classes = React.addons.classSet
      'form-group': true
      'has-error': @props.hasError

    formGroup = rd.div className: classes,
      @props.children

    return @transferPropsTo formGroup

module.exports = {
  Row
  Col
  FormInput
  TextArea
  Label
  FieldError
  FormGroup
}
