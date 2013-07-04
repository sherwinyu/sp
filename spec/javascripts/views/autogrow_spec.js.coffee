xdescribe "Autogrow", ->
  beforeEach ->
    window.afv = afv = Sysys.AutogrowField.create(rawValue: 'wala')
    Ember.run =>
      afv.append()

  it "should run", ->
