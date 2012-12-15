### 
describe "", ->
  loadFixtures 'baz' # located at 'spec/javascripts/fixtures/baz.html.haml'
  it "it is not bar", ->
    v = new Foo()
    expect(v.bar()).toEqual(false)

describe "Sysys", ->
  beforeEach ->
    @appRoot = $('<div>')

  afterEach ->
    # @app.destroy()
    @appRoot = null

  it "should define an Ember Application", ->
    expect(Sysys).toBeDefined()

    # @app = Sysys.initialize 
    # rootElement: @appRoot

    # expect(@appRoot).toHaveClass('ember-application')

    v = new Bar()
    expect(v.foo()).toEqual(false)
    ###

    

