Sysys.DetailController = Ember.ObjectController.extend Sysys.HumonControllerMixin,
  init: ->
    @_super()


Sysys.ActController = Sysys.DetailController.extend
  content: null
  contentDidChange: (->
    chain = Sysys.j2hn({})
    model = @get('content')
    description = model.get 'description'
    description.set 'nodeKey', 'description'
    start_time = model.get 'start_time'
    start_time.set 'nodeKey', 'start time'
    end_time = model.get 'end_time'
    end_time.set 'nodeKey', 'end time'
    detail = model.get 'detail'
    detail.set 'nodeKey', 'details'
    chain.insertAt 0, description, start_time, end_time, detail
    @set 'chain', chain
    chain.set 'hidden', true
  ).observes 'content'

  setTransaction: (->
    if @get('content').transaction.get('isDefault')
      @set('tx', @get('store').transaction())
      @get('tx').add @get('content')
  ).observes('content')

  commitAct: ->
    if @get('content.isDirty')
      @get('content').transaction.commit()
      # @get('content').save()
  forceDirty: (attributeName) ->
    # TODO(syu): refactor to take a 'mid back' function,
    # sandwiched between the willSetProperty and didSetProperty calls
    record = @get('content')
    ctx =
      name: attributeName
      reference: record.get('_reference')
      store: record.store
    record.send 'willSetProperty', ctx
    ctx = name: attributeName
    record.send 'didSetProperty', ctx

  commit: (rawString)->
    @_super(rawString)
    key = @get('activeHumonNode.nodeKey')
    @forceDirty key.replace(' ', '_')

  withinScope: -> false

Sysys.HumonRootController = Sysys.DetailController.extend()
