debugger
describe "Given a ActView view", ->

  beforeEach ->
    @params = 
      description: "just a description"
    @act = Sysys.store.createRecord(Sysys.Act, @params)
    controller = {commit: sinon.spy()}
    @actView = Sysys.ActView.create( content: @act, controller: controller)
    Ember.run =>
      @actView.append()
    
  afterEach ->
    Ember.run =>
      @actView.remove()
    @actView = null

  it "should be defined", ->
    expect(@actView).toBeDefined()

  it "should be in the DOM", ->
    expect(@actView.state).toBe('inDOM')

  it "should be a form", ->
    # expect(@actView.$().class()).toBe('form')

  it "should have a submit button", ->
    expect(@actView.$("button.btn-primary")).toExist()

  it "should show bindings", ->
    #expect($('<div>asdfasdf</div>')).toContainHtml('asdf')
    expect(@actView.$('.description').first()).toContainHtml(@act.get('description'))
    expect(@actView.$('.date')).toHaveText(/empty/)
    Ember.run =>
      @act.set('description', 'something else')
    expect(@actView.$('.description').first()).toContainHtml('something else')

  describe "submit button", ->
    it "should tell the store to commit", ->
      submit = sinon.spy(@actView, "submit")
      debugger
      @actView.$("button").trigger "click"
      expect(submit).toHaveBeenCalledOnce()
      expect(@actView.get('controller').commit).toHaveBeenCalledOnce()

