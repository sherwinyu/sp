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

window.hevInit = (json)->
  opts =
    method: "post"
    resourceName: "data_point"
  @hevForm = new HEVForm("form#my-form", json, opts)
window.hevInit({data_point: {submitted_at: null}})
