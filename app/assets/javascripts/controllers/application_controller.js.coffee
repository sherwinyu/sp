Sysys.ApplicationController = Ember.Controller.extend
  updateCurrentPath: (->
    Sysys.currentPath =  @get('currentPath')
    ).observes 'currentPath'
  debug : false
  git: null
  init: ->
    @set 'git', window?._sp_vars?.git
    @_super()
  actions:
    toggleDbg: ->
      sheet = document.styleSheets[0]
      rules = sheet.cssRules
      @debug ^= true
      if @debug
        sheet.addRule(".node > .debug-auto-hide:not(.node-debug-panel)", "visibility: visible")
      else
        sheet.deleteRule( rules.length - 1 )

Sysys.CurrentUserController = Ember.ObjectController.extend
  isSignedIn: (->
    @get('content')?
  ).property 'content'



Sysys.AuthController = Ember.ObjectController.extend
  content: null
  isSignedIn: (->
    !!@get 'content'
  ).property('content')

  loadCurrentUser: (userPayload) ->
    # Display a flash?
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
    @send 'notify', "Successfully logged in"
    @transitionToRoute 'dashboard'

  _handleLoginFailure: (jqXHR, textSTatus, errorThrown) ->
    if jqXHR.status == 401
      @send 'notify', "Invalid password or email"
      @transitionToRoute 'login'

###

    $.ajax
      url: "/users/sign_in.json"
      type: "POST"
      data:
        "user[email]": route.currentModel.email
        "user[password]": route.currentModel.password
      success: (data) ->
        log.log "Login Msg #{data.user.dummy_msg}"
        me.set 'currentUser', data.user
        route.transitionTo 'home'
      error: (jqXHR, textStatus, errorThrown) ->
        if jqXHR.status==401
          route.controllerFor('login').set "errorMsg", "That email/password combo didn't work.  Please try again"
        else if jqXHR.status==406
          route.controllerFor('login').set "errorMsg", "Request not acceptable (406):  make sure Devise responds to JSON."
        else
          p "Login Error: #{jqXHR.status} | #{errorThrown}"
###
Ember.Application.initializer
  name: 'currentUser'
  initialize: (container) ->
    controller = container.lookup('controller:auth').set 'content'
    container.typeInjection 'controller', 'currentUser', 'controller:auth'
    if window._sp_vars?.currentUser?
      controller.set 'content', Ember.Object.create(email: window._sp_vars.currentUser.email)
