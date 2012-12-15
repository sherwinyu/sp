describe "Given a ActView view", ->

  beforeEach ->
    @actView = Sysys.ActView.create()
    Ember.run ->
      @actView.append()
    
  afterEach ->
    Ember.run ->
      @actView.remove()
    @actView = null

  it "should be defined", ->
    expect(@actView).toBeDefined()

  it "should be in the DOM", ->
    expect(@actView.state).toBe('inDOM')

  it "should have a submit button", ->
    expect(@actView.$("button.btn-primary").length).toEqual(1);
