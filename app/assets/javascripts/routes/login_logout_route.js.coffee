Sysys.LoginRoute = Ember.Route.extend
  beforeModel: (transition) ->
    if @controllerFor('auth').get('isSignedIn')
      @transitionTo "dashboard"
  model: -> Ember.Object.create()
  actions:
    login: (credentials) ->
      @controllerFor("auth").login credentials

Sysys.LogoutRoute = Ember.Route.extend
  beforeModel: ->
    logout = utils.delete
      url: "users/sign_out.json"
    logout.then ->
      location.reload(true)

