# Utility helpers and modifications to help our integration with keymaster.js
# Paritally inspired from https://gist.github.com/garth/8183889

# Returns true if we're in an input, select, text area, or a contenteditable div
# @param e [event] The event from which to judge whether we're in a textfield
# @return True
key.isTyping = (event) ->
  $el = $(event.target || event.srcElement)
  filteredOut = false
  filteredOut ||= $el.prop('tagName') in ['INPUT', 'SELECT', 'TEXTAREA']
  filteredOut ||= $el.is('[contenteditable=true]')

Ember.View.reopen
  bindKey: (shortcut, action) ->
    controller = @get('controller')
    window.key(shortcut, (e, obj) =>
      unless $(e.target).parents("#" + @get('elementId')).length
        return
      action.call(@, e, obj)
    )

  unbindKey: (shorcut) ->
    window.key.unbind shortcut[0]
