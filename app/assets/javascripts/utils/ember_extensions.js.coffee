# An abstraction method over various things that can be focused:
#   - .line-item-selectable elements
#   - and other content-editable elements
#
# Used by goals component and Router#upPressed/downPressed
#
# @param el [Element]
#   el should be either a view that can be smartFocus()'d
#   or an element that can natively respond to focus (in the case of the Goals header element)
Ember.View.smartFocus = (el) ->
  $el = $(el)
  if view = Sysys.vfi($el.attr('id'))
    view.smartFocus()
  else
    $el.focus()
