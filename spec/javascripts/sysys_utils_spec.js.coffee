describe "Sysys utils", ->
  beforeEach ->
    @utils = Sysys.u
    @view = Ember.View.create(content: ["the content"], classNames: ['rightView'])
    @otherView = Ember.View.create(content: ["wrong content"], className: ['wrongView'])
    Ember.run =>
      @view.append()
      @otherView.append()

  afterEach ->
    Ember.run =>
      @view.remove()
      @otherView.remove()
      @view.destroy()
      @otherView.destroy()

  describe "viewFromId", ->
    it "should return the proper view", ->
      id = $('.rightView').attr('id')
      view = Sysys.vfi(id)
      expect(view).toEqual @view
      expect(view.get('content')).toEqual @view.get('content')

  describe "viewFromElement", ->
    it "should return the proper view", ->
      ele = $('.rightView')
      view = Sysys.vfe(ele)
      expect(view).toEqual @view
      expect(view.get('content')).toEqual @view.get('content')

  describe "vf", ->
