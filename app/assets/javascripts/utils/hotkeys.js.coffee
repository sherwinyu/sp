# Returns true if we're in an input, select, text area, or a contenteditable div
key.isTyping = (event) ->
  $el = $(event.target || event.srcElement)
  filteredOut = false
  filteredOut ||= $el.prop('tagName') in ['INPUT', 'SELECT', 'TEXTAREA']
  filteredOut ||= $el.is('[contenteditable=true]')

# An abstraction method over various things that can be focused:
#   - .line-item-selectable elements
#   - and other content-editable elements
# @param el [Element]
#   el should be either a view that can be smartFocus()'d
#   or an element that can natively respond to focus (in the case of the Goals header element)
Ember.View.smartFocus = (el) ->
  $el = $(el)
  if view = Sysys.vfi($el.attr('id'))
    view.smartFocus()
  else
    $el.focus()

Ember.View.reopen
  bindKey: (shortcut, action) ->
    controller = @get('controller')
    window.key(shortcut, (e, obj) =>
      unless $(e.target).parents("#" + @get('elementId')).length
        return
      action.call(@, e, obj)
    )

  unbindKey: (shorcut) ->
    window.key.unbind shortcut
