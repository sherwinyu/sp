describe "HumonNodeView", ->
  beforeEach ->
    @serialized =
      {
        hash2:
          hash1:
            hash0: 0
            hash0b: "b"
        array2:
          [
            [
              314
            ]
          ]
        scalar:
          "scalar"
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
    @humonNodeView = Sysys.HumonNodeView.create content: @humonNode
    window.wala = @humonNodeView

    Ember.run =>
      # @testView.append()
      @humonNodeView.append()

  afterEach ->
    Ember.run =>
      # @humonNodeView.remove()
      # @humonNodeView.destroy()

  it "should display nested node views", ->
    console.log 'chogal'
    debugger
