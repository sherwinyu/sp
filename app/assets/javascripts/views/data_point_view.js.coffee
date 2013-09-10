# responsible for displaying / editing a DataPoint
Sysys.DataPointView = Ember.View.extend
  templateName: 'data_point'
  actions:
    submit: ->
      debugger

class HEVForm
  # TODO split form selector and append selector
  #   form selector for which submit to override
#     append selector for where to insert the json editor
  constructor: (@selector, initialJson, @options) ->
    @setupBindings()
    @hev = Sysys.HumonEditorView.create
            json: initialJson
    @hev.appendTo(@selector)

  setupBindings: ->
    $(@selector).submit (e) =>
      e.preventDefault()
      e.stopPropagation()

      ajaxOpts = @prepareOptions(@options)

      if @options.method is 'put'
        utils.put ajaxOpts
      else if @options.method is 'post'
        utils.post ajaxOpts

  prepareOptions: (args) ->
    ajaxOptions  =
      data: @hev.get('json')
      url: "/#{args.resourceName}s"

    if args.method == "put"
      ajaxOptions.url = ajaxOptions + "/" + args.id

    ajaxOptions

appendForm = ->
  json =
    submitted_at: null
    details: {}
  opts =
    method: "post"
    resourceName: "data_point"
  @hevForm = new HEVForm("#new_data_point", json, opts)

$(document).ready ->
  controller = Ember.ObjectController.extend(
    init: ->
      dpPromise = lu('store:main').find 'data_point',  1
      @set 'content', dpPromise
      dpPromise.then( (dp) =>
        @set 'initialJson', dp.get('details')
      )
      @_super()
    actions:
      submit: ->
        debugger
        @get('content.content').save()
  ).create()

  dpv = Sysys.DataPointView.create
    controller: controller
  dpv.appendTo("body")
