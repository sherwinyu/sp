Sysys.DaysRoute = Ember.Route.extend
  model: (params) ->
    daysPromise = @get('store').findAll 'day'

  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'days'


Sysys.DayRoute = Ember.Route.extend
  model: (params) ->
    dayPromise = @get('store').find 'day', params.day_id

  afterModel: (model, transition, params) ->
    utils.track "visit", route: 'day', day: model.get('id')

  actions:
    error: (reason, transition) ->
      console.error "Error!", reason.toString(), reason.stack

      errorMsg = "Error on #{transition.params.day_id}"
      errorMsg += Sysys.Router.responseToString reason

      @send 'debug', errorMsg

      if reason.statusText == 'Not Found'
        day = @get('store').createRecord 'day' #id: transition.params.day_id
        day.set 'date', transition.params.day_id
        @transitionTo 'days.not_found', day

Sysys.DaysNotFoundRoute = Ember.Route.extend
  serialize: (model, params)->
    return day_id: model.get('date')

  model: (params)->
    day = @get('store').createRecord 'day' #id: transition.params.day_id
    day.set 'date', params.day_id

  renderTemplate: ->
    @render 'days/not_found',
        into: 'application'

  actions:
    initializeDay: (day) ->
      success = (day) => @transitionTo 'day', day
      failure = (response) => @send 'debug', Sysys.Router.responseToString response
      day.save().then success, failure

