describe "ActView", ->

  beforeEach ->
    @act = Ember.Object.create( description: "some description")
    controller = {commit: sinon.spy()}
    @actView = Sysys.ActView.create( context: @act, controller: controller)
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
    expect(@actView.$()).toBe('form')

  it "should have a submit button", ->
    expect(@actView.$("button.btn-primary")).toExist()

  it "should show bindings", ->
    expect(@actView.$('.description').first()).toContainHtml(@act.get('description'))
    Ember.run =>
      @act.set('description', 'something else')
    expect(@actView.$('.description').first()).toContainHtml('something else')

  it "should bind dirtiness class", ->
    @actView.set('context.isDirty', true)
    expect(@actView.$()).toHaveClass("dirty")
    Ember. run =>
      @actView.set('context', Ember.Object.create(isDirty: false))
    expect(@actView.$()).not.toHaveClass("dirty")

  describe "submit button", ->
    it "should tell the store to commit", ->
      submit = sinon.spy(@actView, "submit")
      Ember.run =>
        @actView.$("button").trigger "click"
      expect(submit).toHaveBeenCalledOnce()
      expect(@actView.get('controller').commit).toHaveBeenCalledOnce()

