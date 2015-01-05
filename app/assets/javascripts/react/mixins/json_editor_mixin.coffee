sp.JsonEditorMixin =
  type: ->
    if @props.value? and typeof @props.value == 'object' and @props.value not instanceof Array
      'object'
    else if @props.value? and typeof @props.value == 'object' and @props.value instanceof Array
      'array'
    else
      'literal'

  _upDownShortcuts: (idx, e) ->
    elements = $('.json-field.value-field')
    idx = elements.index $(e.target)

    if e.key == 'ArrowUp'
      idx = (idx + elements.length - 1) % elements.length
    if e.key == 'ArrowDown'
      idx = (idx + elements.length + 1) % elements.length

    el = elements[idx]
    el?.focus()


  _objectValueShortcuts: (e, idx) ->
    if e.key == 'Enter'
      # if @type() is 'literal'
      console.log e, 'enter pressed'
      return true

        # @insertSiblingAt(idx)


