Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  init: ->
    @set 'node', Sysys.j2hn
      abc: 123
      waga: [1,2,3, 4]
    @set 'content', @get('node')
  actions:
    downPressed: (e)->
      elements = $('[tabIndex]')
      idx = elements.index(e.target)
      return if idx == -1
      idx = (idx + elements.length + 1) % elements.length
      elements[idx].focus()

    upPressed: (e)->
      elements = $('[tabIndex]')
      idx = elements.index(e.target)
      return if idx == -1
      idx = (idx + elements.length - 1) % elements.length
      elements[idx].focus()
