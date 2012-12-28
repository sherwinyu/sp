describe "details view (enumerable object", ->
  beforeEach ->
    @serialized = [[[ 
          {
          "array":[1,2,3],
          "object":{"a": true,"b": false},
          "scalar":"mountains",
          },
          [55, 66, 77]
        ], 1]]

        #{a: 0, b: {b0: 5, b1: 7}, c: 1 }
    @details = Sysys.JSONWrapper.recursiveDeserialize(@serialized)
    debugger
    @detailView = Sysys.DetailsView.create context: @details
    @content = [ {val: 1}, {val: 2}, {val: 3} ]
    @content = Ember.ArrayProxy.create(content:[1,2,3])
    # @content = [1, 2, 3]
    @testView = Sysys.TestView.create content: @content
    Ember.run =>
      # @testView.append()
      @detailView.append()

  it "should insert the dom", ->
    5
    expect(false).toBeTruthy()
    ###
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
