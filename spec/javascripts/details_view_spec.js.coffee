describe "details view (enumerable object)", ->
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


        #{a: 0, b: {b0: 5, b1: 7}, c: 1 }
    @details = Sysys.JSONWrapper.recursiveDeserialize(@serialized)
    @detailView = Sysys.DetailsView.create details: @details

    Ember.run =>
      # @testView.append()
      @detailView.append()

    children = @detailView.childrenDetailsViews()
    @hash2view = children[0]
    @hash1view = @hash2view.childrenDetailsViews()[0]
    @hash0view = @hash1view.childrenDetailsViews()[0]
    @hash0bview = @hash1view.childrenDetailsViews()[1]

    @array2view = children[1]
    @array20view = @array2view.childrenDetailsViews()[0]
    @array200view = @array20view.childrenDetailsViews()[0]

    @scalarView = children[2]

  afterEach ->
    # Ember.run => @detailView.remove()
    # @detailView.destroy()

  describe "childrenDetailsViews", ->
    it "get the proper childrenViews", ->
      children = @detailView.childrenDetailsViews()
      expect(children[0].get('details')).toEqual @details.get('hash2')
      expect(children[1].get('details')).toEqual @details.get('array2')
      expect(children[2].get('details')).toEqual @details.get('scalar')

      children0 = children[0].childrenDetailsViews()
      expect(children0[0].get('details')).toEqual @details.get('hash2.hash1')

      children00 = children0[0].childrenDetailsViews()
      expect(children00[0].get('details')).toEqual @details.get('hash2.hash1.hash0')

      children1 = children[1].childrenDetailsViews()
      expect(children1[0].get('details')).toEqual @details.get('array2.0')

      children2 = children[2].childrenDetailsViews()
      expect(children2.length).toEqual 0

  describe "commit", ->
    describe "with nested array" , ->
      beforeEach ->
        @commitValue = ""
        @value = [3,1,[4,1,5]]
        @rd = sinon.stub(Sysys.JSONWrapper, "recursiveDeserialize").returns @value
        @jsonParse = sinon.stub(JSON, "parse").returns("chogal")

      afterEach ->
        @rd.restore()
        @jsonParse.restore()

      describe "on leaf view  (hash0)", ->
        beforeEach ->
          Ember.run => @hash0view.commit()

        it "should update parentDetails", ->
          expect(@hash1view.get('details.hash0')).toEqual @value

        it "should should update parentView.childrenDetailViews", ->
          parentChildrenViews = @hash1view.childrenDetailsViews()
          expect(parentChildrenViews[0].details).toEqual @value

        it "should create appropriate new child views", ->
          childrenViews = @hash1view.childrenDetailsViews()[0].childrenDetailsViews()
          expect(childrenViews[0].details).toEqual 3
          expect(childrenViews[1].details).toEqual 1
          expect(childrenViews[2].details).toEqual [4, 1, 5]
          expect(childrenViews[2].childrenDetailsViews()[0].details).toEqual 4
          expect(childrenViews[2].childrenDetailsViews()[1].details).toEqual 1
          expect(childrenViews[2].childrenDetailsViews()[2].details).toEqual 5

        it "should remove the commiting view and its siblings (hash0 and hash0b)", ->
          expect(@hash0view.state).not.toBe "inDOM"
          expect(@hash0bview.state).not.toBe "inDOM"

      describe "on median view (array20)", ->
        beforeEach ->
          Ember.run => @array20view.commit()

        it "should update parentDetails", ->
          expect(@array2view.get('details.0')).toEqual @value

        it "should should update parentView.childrenDetailViews", ->
          parentChildrenViews = @array2view.childrenDetailsViews()
          expect(parentChildrenViews[0].details).toEqual @value

        it "should create appropriate new child views", ->
          childrenViews = @array2view.childrenDetailsViews()[0].childrenDetailsViews()
          expect(childrenViews[0].details).toEqual 3
          expect(childrenViews[1].details).toEqual 1
          expect(childrenViews[2].details).toEqual [4, 1, 5]
          expect(childrenViews[2].childrenDetailsViews()[0].details).toEqual 4
          expect(childrenViews[2].childrenDetailsViews()[1].details).toEqual 1
          expect(childrenViews[2].childrenDetailsViews()[2].details).toEqual 5

        it "should remove commiting view and its children", ->
          expect(@array20view.state).not.toBe "inDOM"
          expect(@array200view.state).not.toBe "inDOM"

    describe "with nested hashes and arrays", ->
      beforeEach ->
        @hash = Sysys.EnumerableObjectViaObject.create content: {arr: [1,2,3]}
        @value = Sysys.EnumerableObjectViaObject.create content: {hashArray: [@hash, 1]}
        @rd = sinon.stub(Sysys.JSONWrapper, "recursiveDeserialize").returns @value
        @jsonParse = sinon.stub(JSON, "parse").returns("chogal")

      afterEach ->
        @rd.restore()
        @jsonParse.restore()

      describe "on scalarView", ->
        beforeEach ->
          Ember.run => @scalarView.commit()

        it "should update parentView details", ->
          expect(@detailView.details.get('scalar')).toEqual @value

        it "should update parentView.childrenDetailViews", ->
          parentChildrenViews = @detailView.childrenDetailsViews()
          expect(parentChildrenViews[2].details).toEqual @value

        it "should create appropriate new child views", ->
          childrenViews = @detailView.childrenDetailsViews()[2].childrenDetailsViews()
          expect(childrenViews[0].details).toEqual [@hash, 1]
          expect(childrenViews[0].childrenDetailsViews()[0].details).toEqual @hash
          expect(childrenViews[0].childrenDetailsViews()[1].details).toEqual 1
          expect(childrenViews[0].childrenDetailsViews()[0].childrenDetailsViews()[0].details).toEqual @hash.get('arr')
          expect(childrenViews[0].childrenDetailsViews()[0].childrenDetailsViews()[0].childrenDetailsViews()[0].details).toEqual 1
          expect(childrenViews[0].childrenDetailsViews()[0].childrenDetailsViews()[0].childrenDetailsViews()[1].details).toEqual 2
          expect(childrenViews[0].childrenDetailsViews()[0].childrenDetailsViews()[0].childrenDetailsViews()[2].details).toEqual 3

  describe "enterEdit", ->
    beforeEach ->
      Ember.run => @array2view.enterEdit()
    it "should set view.isEditing to true", ->
      expect(@array2view.get('isEditing')).toBe true

    it "should hide children views", ->
      expect(@array2view.$('.details')).not.toExist()

    it "should display a text area", ->
      expect(@array2view.$('textarea')).toExist()

    it "should initialize commit value", ->
      serialized = JSON.stringify Sysys.JSONWrapper.recursiveSerialize @array2view.get 'details'
      expect(@array2view.get('commitValue')).toEqual serialized
      expect(@array2view.$('textarea').val()).toEqual serialized









      ###
commit
  with valid json
    should update currentView's context
    should update currentView's display
    should update parentView's context

enterEdit
  should display a text area
  should populate the textarea with the string representation

  this {{this}} <br>
  key {{key}} <br>
  value {{value}} <br>
  inside each :<br>
  key: {{as_json this}}  <br>
  editable textfield:  <br>

details.view.context:: {{this}} <br>
as_json details.view.context:: {{as_json this}} <br>
KEY VALUE
{{!view Sysys.EditableField view.context.[0].scalar}}
  {{view Ember.TextField valueBinding="0.scalar" propagatesEvents=true class="zorger" initialValueBinding="view.context.0.scalar"}}
KEY VALUE

  {{view Sysys.DetailsView contextBinding="view.context.0"}}
  {{view Sysys.DetailsView contextBinding="view.context.1"}}

  vc.scalar{{view.context.scalar}}<Br>
  vc.arr{{view.context.array}}<Br>
  vc.object{{view.context.object}}<Br>
  vc0{{view.0}}<Br>
  vc1{{view.1}}<Br>
  vc2{{view.2}}<Br>


  {{!if view.context.isEnumearble}}
  {{#each arg in view.context }}
  walala
  {{this}} <br>
  {{view Sysys.DetailsView contextBinding="arg"}}
  {{/each}}
  {{!if}}


  view.context: {{view.context}} <br>
  view.context.as_json: {{as_json view.context}} <br>
  view.context.isEnumerable: {{view.context.isEnumerable}} <br>











    {{#eachO view.context}}
    <br>
    {{#view contentBinding="this" }}
      {{#if view.context.isHash}}
      {{else}}
      {{view._parentView.contentIndex}}:
      {{/if}}
      {{view Sysys.DetailsView contextBinding="this"}}
    {{/view}}
    {{/eachO}}



  vc.scalar{{view.context.scalar.val}}<Br>
  vc.arr{{view.context.array}}<Br>
  vc.object{{view.context.object}}<Br>
  vc0{{view.context.[0].val}}<Br>
  vc1{{view.context.[1].val}}<Br>
  vc2{{view.context.[2].val}}<Br>
