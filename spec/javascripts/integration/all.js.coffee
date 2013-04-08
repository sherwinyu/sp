describe "Acts", ->
  # Sysys.initialize()

  # beforeEach ->
  # Ember.run =>
  # Sysys.router.transitionTo('root.index')

  it "should make a call to Store.loadall call to zorgr", ->
    findAll = sinon.spy(Sysys.store, "findAll")
    Sysys.router.transitionTo('root.index')
    expect(findAll).toHaveBeenCalledOnce


describe "validations", ->
