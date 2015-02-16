net =
  postJSON: ({url, data}) ->
    $.ajax
      contentType: 'application/json'
      data: JSON.stringify(data)
      type: 'POST'
      url: url

  patchJSON: ({url, data}) ->
    $.ajax
      contentType: 'application/json'
      data: JSON.stringify(data)
      type: 'PATCH'
      url: url


  getJSON: ->
    $.getJSON(arguments...)

module.exports = net
