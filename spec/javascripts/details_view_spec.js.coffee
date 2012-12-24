describe "details view (enumerable object", ->
  beforeEach ->
    @serialized = [
          {
            "array":[1,2,3],
          "object":{"a": true,"b": false},
          "scalar":"mountains",
          },
          [55, 66, 77]
        ]
    @details = Sysys.JSONWrapper.recursiveDeserialize(@serialized)
    debugger
    @detailView = Sysys.DetailsView.create context: @details
    Ember.run =>
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
