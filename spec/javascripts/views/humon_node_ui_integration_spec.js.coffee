describe "HumonNode UI integration", ->
  beforeEach ->
    @serialized =
      {
        scalar: ["scalar"]
        hash2:
          hash1:
            hash0: 0
            hash0b: "b"
        array2:
          [
            [
              [1,2,[1,2],[1,2],[1,2,[1,2,[1,2]]]]
            ]
          ]
      }
    json = @serialized
    window.hn = @humonNode = Sysys.HumonUtils.json2humonNode json 
    window.dC = Sysys.DetailController.create( content: hn) 
    window.hnv = @humonNodeView = Sysys.HumonNodeView.create controller: window.dC,  displayStats: true

    Ember.run =>
      @humonNodeView.append()

  afterEach ->
    Ember.run =>
      # @humonNodeView.remove()
      # @humonNodeView.destroy()
  it "should run", ->
