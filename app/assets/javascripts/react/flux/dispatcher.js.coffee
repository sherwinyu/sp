#= require eventEmitter
class Dispatcher
  constructor: ->
    @_callbacks = []
    @_promises = []

  register: (callback) ->
    _callbacks.push callback
    _callbacks.length - 1

  dispatch: (payload) ->
    deferreds = ($.Deferred() for callback in @_callbacks)
    @_promises = (deferred.promise() for deferred in deferreds)

    for [callback, deferred] in _.zip @_callbacks, deferreds
      if callback payload
        deferred.resolve payload
      else
        deferred.reject new Error('Dispatcher called unsuccessfully')

    @_promises = []
    return

  waitFor: (promiseIndices, callback) ->
    selectedPromises = (@_promises[j] for j in promiseIndices)
    $.when(selectedPromises).then callback
    return

dispatcher = new Dispatcher()

module.exports = dispatcher
