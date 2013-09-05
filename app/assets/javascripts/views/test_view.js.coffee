Sysys.TestView = Ember.View.extend
  templateName: "test"
  upperLevelVar: 555
  init: ->
    @_super()
    @set 'node', Sysys.j2hn
      abc: 123
      waga: [1,2,3, 4]
    @set 'json',
      wala: 5
      dooga: 6
