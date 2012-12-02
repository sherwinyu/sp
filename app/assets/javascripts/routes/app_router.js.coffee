Sysys.Router = Ember.Router.extend
  location: 'hash',

  root: Ember.Route.extend

    contacts: Ember.Route.extend
      route: '/contacts'
        
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('actions', Sysys.store.findAll(Sysys.Action))

      index: Ember.Route.extend
        route: '/'

        connectOutlets: (router, context) ->
            router.get('applicationController').connectOutlet('actions')

          ###
    actions: Ember.Route.extend
      route: 'actions'
      
      connectOutlets: (router, context) ->
        actionController = router.get('actionController')
      ###

  enableLogging: true
