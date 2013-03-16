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
    json = @serialized
    @hn = Sysys.HumonUtils.json2humonNode json 
    @detailController = Sysys.DetailController.create()
    @hnv = Sysys.HumonNodeView.create content: @hn, controller: @detailController
    Ember.run => @hnv.append()

  afterEach ->
    Ember.run =>
      @hnv.remove()
      @hnv.destroy()
  describe "humon node bindings", ->
    it "should not set it before insertion", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv_noninserted = Sysys.HumonNodeView.create content: @hn
      expect(@hn.get 'nodeView').toBeNull()

    it "should set it after insertion", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv_inserted = Sysys.HumonNodeView.create content: @hn
      Ember.run => @hnv_inserted.append()
      expect(@hn.get 'nodeView').toBe @hnv_inserted
      Ember.run =>
        @hnv_inserted.remove()
        @hnv_inserted.destroy()

    it "should remove it after removal", ->
      @hn = Sysys.HumonUtils.json2humonNode a: 5
      @hnv_insert = Sysys.HumonNodeView.create content: @hn
      Ember.run => @hnv_insert.append()
      Ember.run => @hnv_insert.remove(); @hnv_insert.destroy()
      expect(@hn.get 'nodeView').toBeNull()

    it "should set bindings on children humon nodes to children humon node views", ->
      @hn = Sysys.HumonUtils.json2humonNode a: ["first", b: 5]
      @hn_a = @hn.getNode 'a'
      @hn_a0 = @hn_a.getNode '0'
      @hn_a1 = @hn_a.getNode '1'
      @hn_a1b = @hn_a1.getNode 'b'
      @hnv_root = Sysys.HumonNodeView.create content: @hn
      expect(@hn.get 'nodeView').toBeNull()
      expect(@hn_a.get 'nodeView').toBeNull()
      expect(@hn_a0.get 'nodeView').toBeNull()
      expect(@hn_a1.get 'nodeView').toBeNull()
      expect(@hn_a1b.get 'nodeView').toBeNull()
      Ember.run => @hnv_root.append()
      expect(@hn.get 'nodeView.content').toEqual @hn
      expect(@hn_a.get 'nodeView.content').toBe @hn_a
      expect(@hn_a0.get('nodeView.content') == @hn_a0).toBeTruthy
      expect(@hn_a1.get 'nodeView.content').toBe @hn_a1
      expect(@hn_a1b.get 'nodeView.content').toBe @hn_a1b
      Ember.run => @hnv_root.remove(); @hnv_root.destroy()
      expect(@hn.get 'nodeView').toBeNull()
      expect(@hn_a.get 'nodeView').toBeNull()
      expect(@hn_a0.get 'nodeView').toBeNull()
      expect(@hn_a1.get 'nodeView').toBeNull()
      expect(@hn_a1b.get 'nodeView').toBeNull()

  describe "isActive", ->
    it "should be true when controller.activeHumonNode points to this humonNodeView's content", ->
      @detailController.set 'activeHumonNode', @hn
      expect(@hnv.get 'isActive').toBe true

    it "should be false when controller doesn't exist ", ->
      @hnv.set 'controller', null
      expect(@hnv.get 'isActive').toBe false

    it "should be false when activeHumonNode doesn't exist ", ->
      @detailController.set 'activeHumonNode', null
      expect(@hnv.get 'isActive').toBe false

    xit "multiple node views can be active together"

    it "should change dynamically with controller.activeHumonNode", ->
      @hn_scalar = @hn.getNode 'scalar'
      @hn_list = @hn.getNode 'list'
      @hn_list_0 = @hn_list.getNode '0'
      @hn_list_1 = @hn_list.getNode '1'
      @hn_list_1_a = @hn_list_1.getNode 'a'

      @detailController.set 'activeHumonNode', @hn
      expect(@hn.get 'nodeView.isActive').toBe true
      expect(@hn_scalar.get 'nodeView.isActive').toBe false
      expect(@hn_list.get 'nodeView.isActive').toBe false
      expect(@hn_list_0.get 'nodeView.isActive').toBe false
      expect(@hn_list_1.get 'nodeView.isActive').toBe false
      expect(@hn_list_1_a.get 'nodeView.isActive').toBe false

      @detailController.set 'activeHumonNode', @hn_scalar
      expect(@hn.get 'nodeView.isActive').toBe false
      expect(@hn_scalar.get 'nodeView.isActive').toBe true
      expect(@hn_list.get 'nodeView.isActive').toBe false
      expect(@hn_list_0.get 'nodeView.isActive').toBe false
      expect(@hn_list_1.get 'nodeView.isActive').toBe false
      expect(@hn_list_1_a.get 'nodeView.isActive').toBe false

      @detailController.set 'activeHumonNode', @hn_list_0
      expect(@hn.get 'nodeView.isActive').toBe false
      expect(@hn_scalar.get 'nodeView.isActive').toBe false
      expect(@hn_list.get 'nodeView.isActive').toBe false
      expect(@hn_list_0.get 'nodeView.isActive').toBe true
      expect(@hn_list_1.get 'nodeView.isActive').toBe false
      expect(@hn_list_1_a.get 'nodeView.isActive').toBe false

      @detailController.set 'activeHumonNode', @hn_list_1_a
      expect(@hn.get 'nodeView.isActive').toBe false
      expect(@hn_scalar.get 'nodeView.isActive').toBe false
      expect(@hn_list.get 'nodeView.isActive').toBe false
      expect(@hn_list_0.get 'nodeView.isActive').toBe false
      expect(@hn_list_1.get 'nodeView.isActive').toBe false
      expect(@hn_list_1_a.get 'nodeView.isActive').toBe true

  it "should display nested node views", ->
    console.log 'chogal'

 
