React = require 'react'
bs = require 'utils/bs'
rd = React.DOM
DateTimePicker = React.createClass

  propTypes:
    onChange: React.PropTypes.func
    value: React.PropTypes.instanceOf(Date)

  handleChange: (e) ->
    e.preventDefault()
    @props.onChange? e
    console.log e.date.toDate()

  $el: -> $(@refs.datetimepicker.getDOMNode())
  _dateTimePicker: -> @$el().data('DateTimePicker')

  syncValue: ->
    @_dateTimePicker().date(@props.value)

  componentDidMount: ->
    @$el().datetimepicker()

    if @props.value?
      @$el().on 'dp.change', @handleChange.bind this
      @syncValue()
      # TODO set up listeners to sync value

  componentDidUpdate: ->
    @syncValue() if @props.value?

  getValue: -> @_dateTimePicker().date()

  render: ->
    rd.div ref: 'datetimepicker', className: 'input-group date',
      bs.FormInput {}
      rd.span className: 'input-group-addon',
        rd.span className: 'glyphicon glyphicon-calendar'

module.exports = DateTimePicker
