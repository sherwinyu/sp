sp.JsonEditorMixin =
  _objectValueShortcuts: (e, idx) ->
    elements = $('.json-field.value-field')
    idx = elements.index $(e.target)

    if e.key == 'ArrowUp'
      idx = (idx + elements.length - 1) % elements.length

    if e.key == 'ArrowDown'
      idx = (idx + elements.length + 1) % elements.length
    console.log el

    el = elements[idx]
    el.focus()

