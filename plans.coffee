wala =

  up: ->
    hn = @get("activeHumonNode")
    @transtiontToHumonNode hn.nextNode()

  # this method should be entirely encapsulated
  # shouldn't need to configure it externally
  #
  # pre conditions:
  #   hn has an active view

  # if passed null, nothing happens
  # if hn has no nodeview, fail silently

  transitionToHumonNode: (hn) ->
    if transitioningToNewNode(hn)
      set('activeHumonNode', hn)
      hn.get('nodeView').send 'activate'

HN =
  events:
    up: ->

    down: ->

  # cases
  #   1) direct response to a user event, currently HNV is inactive
  #   2) direct response to a user event, currently HNV is already active
  focusIn: ->
    if alreadyHasFocus()
      if instanceOf IdxField
          redirect focus
      # general case, do nothing
    unless alreadyHasFocus()
      dC.transitionToHumonNode(@)

  focusOut: (e)->
    @send 'commit'
    e.stopPropagation()

  events:
    activate: ->
      # this guard might not be necessary
      unless alreadyHasFocus()
        @smartFocus()
  smartFocus: ->
    if isCollection

    ahn = @get('activeHumonNode')
    ahnv = @get('activeHumonNodeView')
    context = ahn.get('nodeParent.nodeType')
    nodeKey = ahn.get('nodeKey')
    nodeVal = ahn.get('nodeVal')

    if context == 'hash'
      if nodeKey.length == 0
        @focusKeyField()
      else
        @focusValField()
    else if context == 'list'
      if ahn.get 'hasChildren'
        @focusLabelField()
      else
        @focusValField()
    if ahn.get('isCollection')
      if not ahn.get('hasChildren')
        @focusProxyField()
      else
        @focusLabelField()

CF =
  keyUp: ->
    hnView.up()

  keyDown: ->
    hnView.down()

  # two cases
  # 1) direct response to a user event
  # 2) it is indirect
  focusIn: (e)->
    true
    # hnView.send 'focusIn', @

  focusOut: (e)->
    true
# how to redirect focus?
# simple as do nothing,


########
#
# plans
# direct templates
#
#
# THE MASTER PLAN

