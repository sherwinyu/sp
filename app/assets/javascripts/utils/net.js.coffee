net =
  postJSON: ({url, data}) ->
    return $.ajax
      contentType: 'application/json'
      data: JSON.stringify(data)
      type: 'POST'
      url: url

module.exports = net
