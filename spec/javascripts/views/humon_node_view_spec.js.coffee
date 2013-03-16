describe "HumonNodeView", ->
  beforeEach ->
    @serialized = #a: { a: 1, b: 2 }, flat: 5
      {
        hash2:
          hash1:
            hash0: 0
            hash0b: "b"
        array2:
          [
            [
              314
              415
            ]
            417
          ]
        scalar:
          "scalar" 
        list: [
          "zup"
          a: 5
        ]
      }
    ###
      ###


        #{a: 0, b: {b0: 5, b1: 7}, c: 1 }
        # @details = Sysys.JSONWrapper.recursiveDeserialize(@serialized)

    # json = {a: '5', b: 6 }
    # json = true
    json = [1, "lala", {a: 'b'}]
    json = @serialized
    @humonNode = Sysys.HumonUtils.json2humonNode json 
    window.controller = Sysys.DetailController.create()
    @humonNodeView = Sysys.HumonNodeView.create content: @humonNode, controller: window.controller
    window.controller.set('activeHumonNodeView', @humonNodeView)
    window.controller.set('activeHumonNode', @humonNodeView.get('content'))
    window.wala = @humonNodeView

    Ember.run =>
      @humonNodeView.append()

  afterEach ->
    Ember.run =>
      @humonNodeView.remove()
      @humonNodeView.destroy()

  describe "humon node bindings", ->
    it "should not set it before insertion", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv = Sysys.HumonNodeView.create content: @hn
      expect(@hn.get 'nodeView').toBeNull()

    it "should set it after insertion", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv = Sysys.HumonNodeView.create content: @hn
      Ember.run => @hnv.append()
      expect(@hn.get 'nodeView').toBe @hnv
      Ember.run =>
        @hnv.remove()
        @hnv.destroy()

    it "should remove it after removal", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv = Sysys.HumonNodeView.create content: @hn
      Ember.run => @hnv.append()
      Ember.run => @hnv.remove(); @hnv.destroy()
      expect(@hn.get 'nodeView').toBeNull()

    it "should set bindings on children humon nodes to children humon node views", ->
      @hn = Sysys.HumonUtils.json2humonNode a: ["first", b: 5]
      @hn_a = @hn.getNode 'a'
      @hn_a0 = @hn_a.getNode '0'
      @hn_a1 = @hn_a.getNode '1'
      @hn_a1b = @hn_a1.getNode 'b'
      @hnv = Sysys.HumonNodeView.create content: @hn
      expect(@hn.get 'nodeView').toBeNull()
      expect(@hn_a.get 'nodeView').toBeNull()
      expect(@hn_a0.get 'nodeView').toBeNull()
      expect(@hn_a1.get 'nodeView').toBeNull()
      expect(@hn_a1b.get 'nodeView').toBeNull()
      Ember.run => @hnv.append()
      expect(@hn.get 'nodeView').toEqual @hnv
      expect(@hn_a.get 'nodeView.content').toEqual @hn_a
      # expect(@hn_a0.get 'nodeView.content').toEqual @hn_0
      expect(@hn_a0.get('nodeView.content') == @hn_a0).toBeTruthy
      expect(@hn_a1.get 'nodeView.content').toBe @hn_a1
      expect(@hn_a1b.get 'nodeView.content').toBe @hn_a1b
      Ember.run => @hnv.remove(); @hnv.destroy()
      expect(@hn.get 'nodeView').toBeNull()
      expect(@hn_a.get 'nodeView').toBeNull()
      expect(@hn_a0.get 'nodeView').toBeNull()
      expect(@hn_a1.get 'nodeView').toBeNull()
      expect(@hn_a1b.get 'nodeView').toBeNull()





  it "should display nested node views", ->
    console.log 'chogal'

  describe "focus in", ->
    it "should make a call to controller"
 
