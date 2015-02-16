React = require 'react'
bs = require 'utils/bs'
rd = React.DOM

DateTimePicker = React.createClass
  displayName: 'DateTimePicker'

  propTypes:
    onChange: React.PropTypes.func
    value: React.PropTypes.instanceOf(Date)
    embedded: React.PropTypes.bool

  getDefaultProps: ->
    embedded: true
    defaultValue: moment()

  handleChange: (e) ->
    e.preventDefault()
    @props.onChange? e
    console.log e.date.toDate()

  $el: -> $(@refs.datetimepicker.getDOMNode())
  _dateTimePicker: -> @$el().data('DateTimePicker')

  syncValue: ->
    @_dateTimePicker().date(@props.value)

  componentDidMount: ->
    @$el().datetimepicker
      defaultDate: @props.defaultValue
      showTodayButton: true
      sideBySide: true


    if @props.value?
      @$el().on 'dp.change', @handleChange.bind this
      @syncValue()
      # TODO set up listeners to sync value

  componentDidUpdate: ->
    @syncValue() if @props.value?

  getValue: -> @_dateTimePicker().date()

  renderEmbedded: ->
    bs.FormInput ref: 'datetimepicker', style: @getStyle()

  getStyle: ->
    width: '22%'

  renderGroup: ->
    rd.span ref: 'datetimepicker', className: 'input-group date',
      bs.FormInput {style: @getStyle()}
      rd.span className: 'input-group-addon',
        rd.span className: 'glyphicon glyphicon-calendar'

  render: ->
    if @props.embedded
      @renderEmbedded()
    else
      @renderGroup()

module.exports = DateTimePicker
