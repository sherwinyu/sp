Sysys.TestView = Ember.View.extend
  templateName: "test"
  upperLevelVar: 555
  init: ->
    @set 'content', Sysys.j2hn
      abc: 123
      waga: [1,2,3]
