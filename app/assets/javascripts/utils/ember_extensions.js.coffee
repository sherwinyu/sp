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

_app_ = Sysys
_app_.u =
  viewFromId: (id) -> if id then Ember.get("Ember.View.views.#{id}") else null
  viewFromElement: (ele) -> _app_.u.viewFromId($(ele).first().attr('id'))
  viewFromNumber: (num) -> _app_.u.viewFromId("ember#{num}")
  currentPath: -> _app_.__container__.lookup('controller:application').currentPath
_app_.vfi = _app_.u.viewFromId
_app_.vfe = _app_.u.viewFromElement
_app_.vf = _app_.u.viewFromNumber
_app_.lu = (str) ->
  _app_.__container__.lookup str

window.nfv = (id) ->
  _app_.u.viewFromNumber(id).get('nodeContent')

window.lu = _app_.lu
window.vf = _app_.vf
window.cp = _app_.u.currentPath
window.rt = -> _app_.lu "router:main"
window.ctrl = (name) -> _app_.lu "controller:#{name}"
window.routes = -> _app_.Router.router.recognizer.names
window.msm = (model)-> model.get('stateManager')
window.mcp = (model)-> msm(model).get('currentPath')
window.mcs = (model)-> msm(model).get('currentState')
