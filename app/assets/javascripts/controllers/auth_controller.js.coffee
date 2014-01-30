Sysys.AuthController = Ember.ObjectController.extend
  needs: 'notifications'
  content: null
  isSignedIn: (->
    !!@get 'content'
  ).property('content')

  loadCurrentUser: (userPayload) ->
    @set('content', Ember.Object.create( email: userPayload.email))


  login: (credentials) ->
    me = @
    login = utils.post
      url: "users/sign_in.json"
      data:
        user:
          email: credentials.email
          password: credentials.password
    login.then(
      (data) => @_handleLoginSuccess(data),
      (jqXHR, textStatus, errorThrown) => @_handleLoginFailure(jqXHR,textStatus, errorThrown)
    )

  _handleLoginSuccess: (data) ->
    @loadCurrentUser data
    @get('controllers.notifications').send 'clearAll'
    @send 'notify', "Successfully logged in"
    @transitionToRoute 'dashboard'

  _handleLoginFailure: (jqXHR, textSTatus, errorThrown) ->
    if jqXHR.status == 401
      @send 'notify', "Invalid password or email"
      @transitionToRoute 'login'

Ember.Application.initializer
  name: 'currentUser'
  initialize: (container) ->
    controller = container.lookup('controller:auth').set 'content'
    container.typeInjection 'controller', 'currentUser', 'controller:auth'
    if window._sp_vars?.currentUser?
      controller.set 'content', Ember.Object.create(email: window._sp_vars.currentUser.email)
