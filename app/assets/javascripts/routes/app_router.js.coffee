Sysys.Router = Ember.Router.extend
  location: 'hash',

  root: Ember.Route.extend

    actions: Ember.Route.extend
      route: '/actions'
        
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('actions', Sysys.store.findAll(Sysys.Action))

      index: Ember.Route.extend
        route: '/'

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('actions')


      action: Ember.Route.extend
        route: '/action/:action_id'

        connectOutlets: (router, action) ->
          debugger
          router.get('actionsController').connectOutlet('action', action)





          ###
    actions: Ember.Route.extend
      route: 'actions'
      
      connectOutlets: (router, context) ->
        actionController = router.get('actionController')
      ###

  enableLogging: true
