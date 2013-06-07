wala =

up: ->
  hn = @get("activeHumonNode")
  @transtiontToHumonNode hn.nextNode()

  # this method should be entirely encapsulated
  # shouldn't need to configure it externally
  #
  # pre conditions:
  #   hn has an active view
  #
  # if passed null, nothing happens
  # if hn has no nodeview, fail silently
  #
transitionToHumonNode: (hn) ->
   set('activeHumonNode', hn)
   hn.get('nodeView').focus()


