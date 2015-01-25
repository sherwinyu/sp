EventEmitter = require('events').EventEmitter

CHANGE_EVENT = 'change'

class Store extends EventEmitter
  constructor: (dispatcher) ->
    @dispatchIndex = dispatcher.register (payload) => @payloadHandler(payload)
    @resetState()

  payloadHandler: (payload) -> throw new Error('payloadHandler has not been implemented')

  resetState: -> throw new Error('resetState has not been implemented')

  listenerMixin: (listenerName) ->
    store = this
    return {
      componentWillMount: ->
        listener = @[listenerName]
        if not listener?
          console.warn "#{listenerName} is not a valid instance method!"
        store.addChangeListener listener
        return
      componentWillUnmount: ->
        listener = @[listenerName]
        store.removeChangeListener listener
        return
    }

  emitChange: (context) ->
    @emit CHANGE_EVENT, context
    #@trigger(CHANGE_EVENT, context)

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    if not callback?
      throw new Error('Attempted to removeChangeListener with null callback')
    @off(CHANGE_EVENT, callback)

# $.extend Store.prototype, EventEmitter

module.exports = Store

