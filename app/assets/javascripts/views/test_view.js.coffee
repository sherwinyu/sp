Sysys.TestView = Ember.View.extend
  templateName: "test"
  upperLevelVar: 555
  init: ->
    @_super()
    @set 'content', Sysys.j2hn
      abc: 123
      waga: [1,2,3]
    @set 'json',
      wala: 5
      dooga: 6
