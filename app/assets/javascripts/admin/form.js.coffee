window.hevInit = (json)->
  opts =
    method: "post"
    resourceName: "data_point"
  @hevForm = new HEVForm("form#my-form", json, opts)
window.hevInit({data_point: {submitted_at: null}})
