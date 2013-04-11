#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require_tree ./humon
@Sysys = Ember.Application.create
  LOG_TRANSITIONS: true
  # if @TESTING
  # Sysys.deferReadiness()

Sysys.u =
  viewFromId: (id) -> Ember.get("Ember.View.views.#{id}")
  viewFromElement: (ele) -> Sysys.u.viewFromId($(ele).first().attr('id'))
  viewFromNumber: (num) -> Sysys.u.viewFromId("ember#{num}")
Sysys.vfi = Sysys.u.viewFromId
Sysys.vfe = Sysys.u.viewFromElement
Sysys.vf = Sysys.u.viewFromNumber

window.setCursor = (node, pos) ->
  node = if typeof node == "string" || node instanceof string
           document.getElementById node
         else
           node
  unless node
    return false
  if node.createTextRange
    textRange = node.createTextRange()
    textRange.collapse true
    textRange.moveEnd pos
    textRange.select()
    true
  else if node.setSelectionRange
    node.setSelectionRange pos, pos
    true
  false

window.getCursor = (node) ->
  $(node).prop('selectionStart')

window.delay = (ms, callback) -> setTimeout(ms, callback)
