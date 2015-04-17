React = require 'react'
bs = require 'utils/bs'
rd = React.DOM

DateTimePicker = React.createClass
  displayName: 'DateTimePicker'

  propTypes:
    onChange: React.PropTypes.func
    # TODO (2015-04-16) unify (or standardize) whether value is a moment or a date
    value: React.PropTypes.instanceOf(Date)
    embedded: React.PropTypes.bool
    syncWithCurrentTime: React.PropTypes.bool

  getDefaultProps: ->
    embedded: true
    defaultValue: moment()
    syncWithCurrentTime: true

  handleChange: (e) ->
    e.preventDefault()
    @props.onChange? e

  $el: -> $(@refs.dateTimePicker.getDOMNode())
  _dateTimePicker: -> @$el().data('DateTimePicker')

  _syncWithCurrentTime: ->
    console.log 'hello'
    @_dateTimePicker().date new Date()

  syncValue: ->
    @_dateTimePicker().date(@props.value)

  componentWillUnmount: ->
    $(window).off 'focus.dateTimePicker'

  componentDidMount: ->
    @$el().datetimepicker
      defaultDate: @props.defaultValue
      showTodayButton: true
      sideBySide: true

    # Only allow sync with current time if no value is specified
    if @props.syncWithCurrentTime and not @props.value?
      $(window).on 'focus.dateTimePicker', => @_syncWithCurrentTime()

    if @props.value?
      @$el().on 'dp.change', @handleChange.bind this
      @syncValue()
      # TODO set up listeners to sync value

  componentDidUpdate: ->
    @syncValue() if @props.value?

  getValue: -> @_dateTimePicker().date()

  renderEmbedded: ->
    bs.FormInput ref: 'dateTimePicker', style: @getStyle()

  getStyle: ->
    width: '22%'

  renderGroup: ->
    rd.span ref: 'dateTimePicker', className: 'input-group date',
      bs.FormInput {style: @getStyle()}
      rd.span className: 'input-group-addon',
        rd.span className: 'glyphicon glyphicon-calendar'

  render: ->
    if @props.embedded
      @renderEmbedded()
    else
      @renderGroup()

module.exports = DateTimePicker
